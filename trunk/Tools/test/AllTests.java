import junit.framework.Test;
import junit.framework.TestSuite;

//	Exploring how we might dynamically set up test suites.
public class AllTests {

	public static Test suite() {
		TestSuite suite = new TestSuite("Test for default package");
		//$JUnit-BEGIN$

		//$JUnit-END$
		return suite;
	}

}
