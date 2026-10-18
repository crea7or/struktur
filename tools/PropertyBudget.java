import java.util.*;
import javax.xml.parsers.*;
import org.w3c.dom.*;
import com.garmin.monkeybrains.serialization.Serializer;

// Host-only use of the installed Garmin SDK serializer; no app runtime code.
class PropertyBudget {
    public static void main(String[] args) throws Exception {
        var xml=DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(args[0]);
        var nodes=xml.getElementsByTagName("property");
        var defaults=new LinkedHashMap<String,Object>();
        var maximum=new LinkedHashMap<String,Object>();
        for(int i=0;i<nodes.getLength();i++) {
            var p=(Element)nodes.item(i);var key=p.getAttribute("id");
            if(!key.matches("[a-z][a-z0-9_]{0,7}")) throw new IllegalArgumentException("Invalid compact key");
            Object value=switch(p.getAttribute("type")) {
                case "number" -> Integer.valueOf(p.getTextContent().trim());
                case "boolean" -> Boolean.valueOf(p.getTextContent().trim());
                case "string" -> p.getTextContent();
                default -> throw new IllegalArgumentException("Unsupported property type");
            };
            if(defaults.put(key,value)!=null) throw new IllegalArgumentException("Duplicate key");
            // Integer/Boolean widths are fixed; Team is the only variable-length value.
            if(value instanceof String text && (!key.equals("team") || text.length()>32 || !text.chars().allMatch(c -> c>=32 && c<=126))) throw new IllegalArgumentException("Invalid Team text");
            maximum.put(key,value instanceof String?"W".repeat(32):value);
        }
        var normal=Serializer.serialize(defaults);var worst=Serializer.serialize(maximum);
        int limit=Integer.parseInt(args[1]);
        if(normal.length>limit || worst.length>limit) throw new IllegalStateException("Property budget exceeded");
        System.out.printf("{\"properties\":%d,\"default_bytes\":%d,\"maximum_bytes\":%d,\"limit_bytes\":%d}%n",defaults.size(),normal.length,worst.length,limit);
    }
}
