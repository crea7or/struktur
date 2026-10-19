using System;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Text;

// Own the complete runner tree before it can spawn Java or shell.exe.
// File handles avoid redirected-pipe waits after an intermediate process exits.
public sealed class StrukturSdkRun : IDisposable {
    IntPtr job, process;
    public int Id { get; private set; }
    [StructLayout(LayoutKind.Sequential)] struct Security { public int length; public IntPtr descriptor; [MarshalAs(UnmanagedType.Bool)] public bool inherit; }
    [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)] struct Startup { public int size; public string reserved, desktop, title; public int x,y,w,h,xchars,ychars,fill,flags; public short show, reserved2; public IntPtr reservedPtr, input, output, error; }
    [StructLayout(LayoutKind.Sequential)] struct ProcessInfo { public IntPtr process, thread; public int pid, tid; }
    [StructLayout(LayoutKind.Sequential)] struct BasicLimit { public long perProcess, perJob; public uint flags; public UIntPtr minWorking, maxWorking; public uint active; public UIntPtr affinity; public uint priority, scheduling; }
    [StructLayout(LayoutKind.Sequential)] struct IoCounters { public ulong readOps,writeOps,otherOps,readBytes,writeBytes,otherBytes; }
    [StructLayout(LayoutKind.Sequential)] struct ExtendedLimit { public BasicLimit basic; public IoCounters io; public UIntPtr processMemory,jobMemory,peakProcess,peakJob; }
    [DllImport("kernel32.dll",SetLastError=true)] static extern IntPtr CreateJobObject(IntPtr a,string name);
    [DllImport("kernel32.dll",SetLastError=true)] static extern bool SetInformationJobObject(IntPtr j,int kind,ref ExtendedLimit info,uint size);
    [DllImport("kernel32.dll",SetLastError=true)] static extern bool AssignProcessToJobObject(IntPtr j,IntPtr p);
    [DllImport("kernel32.dll",SetLastError=true)] static extern bool TerminateJobObject(IntPtr j,uint code);
    [DllImport("kernel32.dll",SetLastError=true)] static extern bool TerminateProcess(IntPtr p,uint code);
    [DllImport("kernel32.dll",SetLastError=true,CharSet=CharSet.Unicode)] static extern bool CreateProcess(string app,StringBuilder args,IntPtr pa,IntPtr ta,bool inherit,uint flags,IntPtr env,string cwd,ref Startup startup,out ProcessInfo info);
    [DllImport("kernel32.dll",SetLastError=true,CharSet=CharSet.Unicode)] static extern IntPtr CreateFile(string path,uint access,uint share,ref Security security,uint disposition,uint flags,IntPtr template);
    [DllImport("kernel32.dll",SetLastError=true)] static extern uint ResumeThread(IntPtr t);
    [DllImport("kernel32.dll",SetLastError=true)] static extern uint WaitForSingleObject(IntPtr h,uint ms);
    [DllImport("kernel32.dll",SetLastError=true)] static extern bool GetExitCodeProcess(IntPtr p,out uint code);
    [DllImport("kernel32.dll")] static extern bool CloseHandle(IntPtr h);
    static void Check(bool ok) { if(!ok) throw new Win32Exception(Marshal.GetLastWin32Error()); }
    static IntPtr File(string path,bool input) {
        var s=new Security {length=Marshal.SizeOf(typeof(Security)),inherit=true};
        var h=CreateFile(path,input?0x80000000u:0x40000000u,3,ref s,input?3u:2u,0x80,IntPtr.Zero);
        Check(h!=new IntPtr(-1)); return h;
    }
    public static StrukturSdkRun Start(string executable,string arguments,string cwd,string stdout,string stderr) {
        var run=new StrukturSdkRun(); var p=new ProcessInfo();
        IntPtr output=IntPtr.Zero,error=IntPtr.Zero,input=IntPtr.Zero;
        try {
            run.job=CreateJobObject(IntPtr.Zero,null);Check(run.job!=IntPtr.Zero);
            var limits=new ExtendedLimit();limits.basic.flags=0x2000; // KILL_ON_JOB_CLOSE
            Check(SetInformationJobObject(run.job,9,ref limits,(uint)Marshal.SizeOf(typeof(ExtendedLimit))));
            output=File(stdout,false);error=File(stderr,false);input=File("NUL",true);
            var s=new Startup {size=Marshal.SizeOf(typeof(Startup)),flags=0x101,show=0,input=input,output=output,error=error};
            Check(CreateProcess(executable,new StringBuilder("\""+executable+"\" "+arguments),IntPtr.Zero,IntPtr.Zero,true,0x08000004,IntPtr.Zero,cwd,ref s,out p));
            run.process=p.process;run.Id=p.pid;
            Check(AssignProcessToJobObject(run.job,p.process));
            Check(ResumeThread(p.thread)!=0xffffffff);return run;
        } catch { if(p.process!=IntPtr.Zero) TerminateProcess(p.process,1);run.Dispose();throw; }
        finally { foreach(var h in new[]{p.thread,output,error,input}) if(h!=IntPtr.Zero) CloseHandle(h); }
    }
    public bool HasExited { get { return WaitForSingleObject(process,0)==0; } }
    public int ExitCode { get { uint code;Check(GetExitCodeProcess(process,out code));if(code==259) throw new InvalidOperationException("Runner is still active");return unchecked((int)code); } }
    public bool WaitForExit(int milliseconds) { var result=WaitForSingleObject(process,(uint)milliseconds);if(result==0xffffffff) throw new Win32Exception();return result==0; }
    public void Stop() { if(job!=IntPtr.Zero) { Check(TerminateJobObject(job,1));if(process!=IntPtr.Zero && !WaitForExit(5000)) throw new TimeoutException("Runner cleanup exceeded five seconds"); } }
    public void Dispose() { if(job!=IntPtr.Zero) { CloseHandle(job);job=IntPtr.Zero; } if(process!=IntPtr.Zero) { CloseHandle(process);process=IntPtr.Zero; } }
}
