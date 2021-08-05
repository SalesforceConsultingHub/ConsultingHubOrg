@isTest
public class OnboardingHelperTest {
	@isTest
    public static void getLearningsTest(){
        List<String> l = new List<String>{'IA; Sales Cloud; Service Cloud'};
        OnboardingHelper.getLearnings(l);
    }
}