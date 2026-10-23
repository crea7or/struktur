"""Host regressions for memory observation; native runtime evidence stays separate."""
import unittest
import sys
from pathlib import Path
from report_memory_validation import completion, allocation


class MemoryObservationTests(unittest.TestCase):
    def record(self, prefix='DF_NATIVE_MEMORY_DONE', **changes):
        fields=dict(samples=50,max_used=126184,min_free=1336,total_low=127520,total_high=127520,native_compute=30,native_draw=30,elapsed_ms=30000)
        fields.update(changes)
        return prefix+' product=edge1030 '+' '.join(f'{k}={v}' for k,v in fields.items())+'\n'

    def test_low_headroom_is_reported_without_overhead_subtraction(self):
        metrics=completion(self.record(),'edge1030','native')
        allocation(metrics,131072)
        self.assertEqual(126184,metrics['max_used'])
        self.assertEqual(1336,metrics['min_free'])

    def test_completion_required_exactly_once(self):
        for text in ['',self.record()*2,self.record().replace('edge1030','edge1040')]:
            with self.subTest(text=text), self.assertRaises(AssertionError):
                completion(text,'edge1030','native')

    def test_duplicate_metrics_fail(self):
        with self.assertRaises(AssertionError):
            completion(self.record().strip()+' max_used=1\n','edge1030','native')

    def test_missing_native_coverage_or_metric_fails(self):
        for text in [self.record(native_compute=9),self.record(native_draw=2),self.record(elapsed_ms=29999),self.record().replace('samples=50 ','')]:
            with self.subTest(text=text), self.assertRaises(AssertionError):
                completion(text,'edge1030','native')

    def test_crash_cannot_be_hidden_by_completion(self):
        for error in ['Out Of Memory','Stack Overflow','Watchdog Tripped','DF_MEMORY_FAIL']:
            with self.subTest(error=error), self.assertRaises(AssertionError):
                completion(error+'\n'+self.record(),'edge1030','native')

    def test_allocation_and_ceiling_remain_absolute(self):
        for fields in [dict(max_used=127521),dict(total_high=131073),dict(total_low=0)]:
            with self.subTest(fields=fields), self.assertRaises(AssertionError):
                allocation(completion(self.record(**fields),'edge1030','native'),131072)

    def test_matrix_uses_native_dc_and_two_retained_banks(self):
        root=Path(__file__).resolve().parents[1]
        driver=(root/'validation/memory/MemoryValidation.mc').read_text()
        case=driver.split('function runCase(dc,index) {',1)[1].split('function failedPrecondition',1)[0]
        self.assertNotIn('MemoryAreaDc',driver)
        self.assertIn('_renderer.draw(dc,_snapshot,_settings)',case)
        self.assertLess(case.index('_reference=null'),case.index('_settings=caseSettings(index)'))
        self.assertLess(case.index('_snapshot=null'),case.index('_snapshot=_engine.compute('))
        self.assertIn('const CASES=216',driver)
        self.assertIn('const CYCLES=3',driver)

    def test_sampling_has_no_console_or_formatting_path(self):
        source=(Path(__file__).resolve().parents[1]/'validation/memory/MemoryObservation.mc').read_text()
        sample=source.split('function sample(stage) {',1)[1].split('function report()',1)[0]
        for forbidden in ['System.print','System.println','.toString(','.format(','report(']:
            self.assertNotIn(forbidden,sample)
        self.assertIn('System.getSystemStats()',sample)
        self.assertIn('throw new Lang.InvalidValueException',sample)


if __name__ == '__main__':
    unittest.main(testRunner=unittest.TextTestRunner(stream=sys.stdout))
