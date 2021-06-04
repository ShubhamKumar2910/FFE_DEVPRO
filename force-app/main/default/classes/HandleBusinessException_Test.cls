@isTest
public class HandleBusinessException_Test{
    
    public class BaseException extends Exception {}
    
    public static testmethod void exceptionMethod(){
        
        test.startTest();
        User auser = Utility_Test.createUser('HandleBusinessException_Test@gmail.com');
        System.runAs(auser){
            try{
                throw new BaseException('This is bad');
            }catch (BaseException e) { 
                HandleBusinessException.captureError('TestClass','TestMethod', e);
                SchedulableContext SC;
                HandleBusinessException_Batch exceptionBatch = new HandleBusinessException_Batch();
                exceptionBatch.execute(SC); 
            }
        } 
        test.stopTest();
    }
    
}