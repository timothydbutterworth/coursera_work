import java.io.File;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;

public class jrubySolver {

	/**
	 * @param args
	 * @throws Throwable 
	 */
	public static void main(String[] args) throws Throwable {
		addFileToClasspath("/home/tim/handyjars/jruby-complete-1.7.4.jar");

        final ScriptEngine rubyEngine = new ScriptEngineManager().getEngineByName("jruby");
        rubyEval(rubyEngine, "puts 'hello world!'"); // works
        StringBuffer sb = new StringBuffer();
        sb.append("10.times do |i| \n");
        sb.append("	puts i \n");
        sb.append("end");
        System.out.println(sb.toString());
        rubyEval(rubyEngine, sb.toString());
        rubyEval(rubyEngine, "require 'tempfile'");  // fails to load 'tmpdir'
        rubyEval(rubyEngine, "require 'fileutils'"); // fails to load 'fileutils'

	}
    private static void rubyEval(ScriptEngine rubyEngine, final String code) {
        try {
            rubyEngine.eval(code);
        } catch (final Throwable e) { System.out.println(e.getMessage()); };
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
