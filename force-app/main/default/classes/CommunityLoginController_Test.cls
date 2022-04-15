@isTest
public class CommunityLoginController_Test {
    @IsTest
    static void testLoginWithInvalidCredentials() {
        System.assertEquals('Argument 1 cannot be null', CommunityLoginController.checkPortal('testUser', 'fakepwd'));
    }
}