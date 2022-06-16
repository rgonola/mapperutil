/**
 * @File Name          : VFUtil_Test.cls
 * @Description        : 
 * @Author             : Raj Gonola 
 * @Group              : 
 * @Last Modified By   : Raj Gonola 
 * @Last Modified On   : 6/22/2019, 12:16:55 PM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    6/22/2019, 12:16:55 PM   Raj Gonola      Initial Version
**/
@IsTest
public with sharing class VFUtil_Test {
     // Test Coverage
    static TestMethod void testAddMessages() {
        String message = 'Test Message';
        VFUtil.addInfoMessage( message);
        VFUtil.addWarningMessage( message);
        VFUtil.addConfirmMessage( message);
        VFUtil.addErrorMessage( message);
        VFUtil.addFatalMessage( message);
        string x='';
        List<String> lststrng = new List<String>();
        VFUtil.isEmpty(lststrng);
        Set<String> setstrng = new Set<String>();
        VFUtil.isEmpty(setstrng);
        Boolean y=VFUtil.isEmpty(x);
        System.assert( VFUtil.hasMessage( message));
        System.assert( !VFUtil.hasMessage( 'Negative Test Case'));
    }
}