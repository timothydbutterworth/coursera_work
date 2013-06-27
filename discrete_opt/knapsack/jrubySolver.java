import java.io.File;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.ArrayList;
import java.util.List;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;

public class jrubySolver {

    /**
     * @param args
     * @throws Throwable 
     */
//  public static void main(String[] args) {
//        try {
//            solve(args);
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//    }
    public static void main(String[] args) throws Throwable {
        
        String fileName = null;
        
        // get the temp file name
        for(String arg : args){
            if(arg.startsWith("-file=")){
                fileName = arg.substring(6);
            } 
        }
        if(fileName == null) return;
        
        addFileToClasspath("/home/tim/handyjars/jruby-complete-1.7.4.jar");

        final ScriptEngine rubyEngine = new ScriptEngineManager().getEngineByName("jruby");
        StringBuffer sb = getRubyReadingRubyScript();//new StringBuffer();

        StringBuffer script = new StringBuffer();
        rubyEngine.put("script", script);
        rubyEngine.put("file", fileName);
        
        List<String> solution = new ArrayList<String>();
        StringBuffer resultV = new StringBuffer();
        
        rubyEngine.put("solution", solution);
        rubyEngine.put("resultV", resultV);
        rubyEngine.put("home", "/home/tim/corsera/discrete_opt/knapsack");
    /*
     * run the script to load the real script first
     */
        rubyEval(rubyEngine, sb.toString());
        /**
         * run the script loaded by the ruby loader script
         */
        rubyEval(rubyEngine, script.toString());
        
        System.out.println(resultV.toString());
        boolean start = true;
        for(String s:solution){
            System.out.print(((start) ? "": " ") + s);
            start = false;
        }
        System.out.println("");
    }
    private static StringBuffer getRubyReadingRubyScript() {
        StringBuffer sb = new StringBuffer();
        sb.append("file = File.new('/home/tim/corsera/discrete_opt/knapsack/genetic.rb','r') \n");
        sb.append("scrpt = '' \n");
        // sb.append("puts $script.to_s \n");
        sb.append("file.each do |l| \n");
        sb.append(" $script.append(l) \n");
        sb.append("end \n");
        sb.append("file.close");
        return sb;
    }
    private static void rubyEval(ScriptEngine rubyEngine, final String code) {
        try {
            rubyEngine.eval(code);
        } catch (final Throwable e) { //System.out.println(e.getMessage()); 
        };
    }
    public static void addFileToClasspath(final String path) throws Throwable {
        final File file = new File(path);
        final URLClassLoader sysloader = (URLClassLoader) ClassLoader.getSystemClassLoader();
        final Class<?> sysclass = URLClassLoader.class;
        final Method method = sysclass.getDeclaredMethod("addURL", new Class<?>[] {URL.class});
        method.setAccessible(true);
        method.invoke(sysloader, new Object[] {file.toURI().toURL()});
    }
}
