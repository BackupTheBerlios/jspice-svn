package org.openspice.jspice.main.test;

import junit.framework.Test;
import junit.framework.TestSuite;

public class AllTests {

	public static Test suite() {
		TestSuite suite = new TestSuite(
				"Test for org.openspice.jspice.main.test");
		//$JUnit-BEGIN$
		suite.addTest(TestXMLTags.suite());
		suite.addTest(TestSimpleArithmetic.suite());
		suite.addTest(TestElement.suite());
		suite.addTest(TestLambda.suite());
		suite.addTest(TestFor.suite());
		suite.addTest(TestLiteralEvaluation.suite());
		suite.addTestSuite(StartUpTest.class);
		//$JUnit-END$
		return suite;
	}

}
