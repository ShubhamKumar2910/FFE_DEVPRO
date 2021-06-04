@isTest
public class TrainingAndSkillDevelopment_Test {
    
    
    static testmethod void mailAndApproval(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            
            String currentFinancialYear =  Utility.financialYear();
            Contact student = Utility_Test.insertSingleStudent('jayanthtest1','b');
            student.Financial_year__c = currentFinancialYear;    
            student.Current_year__c = System.label.X2nd_year;
            student.Course__c = 'Integrated MTech';
            student.English_Spoken_Score__c = 100;
            student.Aptitude_Analytical_Score__c = 50;
            insert student;
            Contact studentthirdYear = Utility_Test.insertSingleStudent('jayanthtest2','b');
            studentthirdYear.Financial_year__c = currentFinancialYear;    
            studentthirdYear.Current_year__c = system.label.X3rd_year ;
            studentthirdYear.Course__c = 'Integrated MTech';
            studentthirdYear.English_Spoken_Score__c = 100;
            studentthirdYear.Aptitude_Analytical_Score__c = 50;
            insert studentthirdYear;
            Contact studentfourthYear = Utility_Test.insertSingleStudent('jayanthtest2','b');
            studentfourthYear.Financial_year__c = currentFinancialYear;    
            studentfourthYear.Current_year__c = System.label.X4th_year ;
            studentfourthYear.English_Spoken_Score__c = 100;
            studentfourthYear.Course__c = 'Integrated MTech';
            studentfourthYear.Aptitude_Analytical_Score__c = 50;
            insert studentfourthYear;
            
            TrainingAndSkillDevelopment_CTRL tsdctrl = new TrainingAndSkillDevelopment_CTRL();
            TrainingAndSkillDevelopment_CTRL.getSecondYearData();   
            
            Training_Master__c tms1 = new Training_Master__c(Amcat_dependence_check__c=true,Name='English app1',Points__c=100,Student_Years__c='2nd Year',Start_Month__c='January',End_Month__c='March',Milestone_2__c='April',Training_Type__c='English');
            insert tms1;
            
            Training_Master__c tms2 = new Training_Master__c(Amcat_dependence_check__c=true,Name='Aptitude app1',Points__c=100,Student_Years__c='2nd Year',Start_Month__c='January',End_Month__c='March',Milestone_2__c='April',Training_Type__c='Aptitude');
            insert tms2;
            
            Training_Master__c tms3 = new Training_Master__c(Amcat_dependence_check__c=true,Name='IT',Points__c=100,Student_Years__c='3rd Year',Start_Month__c='January',End_Month__c='March',Milestone_2__c='April',Training_Type__c='IT');
            insert tms3;
            
            Training_Master__c tms4 = new Training_Master__c(Amcat_dependence_check__c=true,Name=system.label.Mock_Interview_HR,Points__c=100,Student_Years__c='4th Year',Start_Month__c='January',End_Month__c='March',Milestone_2__c='April',Training_Type__c=system.label.Mock_Interview_HR);
            insert tms4;
            
            Training_Master__c tms5 = new Training_Master__c(Amcat_dependence_check__c=true,Name=system.label.Mock_Interview_Tech,Points__c=100,Student_Years__c='4th Year',Start_Month__c='January',End_Month__c='March',Milestone_2__c='April',Training_Type__c=system.label.Mock_Interview_Tech);
            insert tms5;
            
            Training_Master__c tms6 = new Training_Master__c(Amcat_dependence_check__c=true,Name=system.label.Mock_Interview_Tech,Points__c=100,Student_Years__c='4th Year',Start_Month__c='January',End_Month__c='March',Milestone_2__c='April',Training_Type__c='Mock Interviews');
            insert tms6;
            Student_Training__c stm1 = new Student_Training__c(Conclusion__c='ongoing',Student_ID__c=student.id,Training_Code__c=tms1.id,External_ID__c=student.FFE_ID__c+'-'+tms1.Name);
            insert stm1;
            
            Student_Training__c stm2 = new Student_Training__c(Conclusion__c='ongoing',Student_ID__c=student.id,Training_Code__c=tms2.id,External_ID__c=student.FFE_ID__c+'-'+tms2.Name);
            insert stm2;
            
            Student_Training__c stm3 = new Student_Training__c(Conclusion__c='ongoing',Student_ID__c=studentthirdYear.id,Training_Code__c=tms3.id,External_ID__c=studentthirdYear.FFE_ID__c+'-'+tms3.Name);
            insert stm3;
            
            Student_Training__c stm4 = new Student_Training__c(Conclusion__c='ongoing',Student_ID__c=studentfourthYear.id,Training_Code__c=tms4.id,External_ID__c=studentfourthYear.FFE_ID__c+'-'+tms4.Name);
            insert stm4;
            
            Student_Training__c stm5 = new Student_Training__c(Conclusion__c='ongoing',Student_ID__c=studentfourthYear.id,Training_Code__c=tms5.id,External_ID__c=studentfourthYear.FFE_ID__c+'-'+tms5.Name);
            insert stm5;
            
            Student_Training__c stm6 = new Student_Training__c(Conclusion__c='ongoing',Student_ID__c=studentthirdYear.id,Training_Code__c=tms6.id,External_ID__c=studentthirdYear.FFE_ID__c+'-'+tms6.Name);
            insert stm6;
            
            
            Vendor__c v1 = new Vendor__c(Training_Master__c=tms1.Id,Vendor_Code__c='E001',Vendor_URL__c='https://google.com');
            insert v1;
            
            Vendor__c v2 = new Vendor__c(Training_Master__c=tms2.Id,Vendor_Code__c='A001',Vendor_URL__c='https://google.com');
            insert v2;
            
            Vendor__c v3 = new Vendor__c(Training_Master__c=tms3.Id,Vendor_Code__c='I001',Vendor_URL__c='https://google.com');
            insert v3;
            
            Vendor__c v4 = new Vendor__c(Training_Master__c=tms4.Id,Vendor_Code__c='MH001',Vendor_URL__c='https://google.com');
            insert v4;
            
            Vendor__c v5 = new Vendor__c(Training_Master__c=tms5.Id,Vendor_Code__c='MT001',Vendor_URL__c='https://google.com');
            insert v5;
            
            Training_Result__c tr1 = new Training_Result__c(Student_Training_Mapping__c=stm1.id,FFE_ID__c=student.FFE_ID__c,STU_ID__c=tms1.Name,Vendor_Code__c='E001');
            insert tr1;
            
            Training_Result__c tr2 = new Training_Result__c(Student_Training_Mapping__c=stm2.id,FFE_ID__c=student.FFE_ID__c,STU_ID__c=tms2.Name,Vendor_Code__c='A001');
            insert tr2;
            
            
            Training_Result__c tr3 = new Training_Result__c(Student_Training_Mapping__c=stm1.id,FFE_ID__c=studentthirdYear.FFE_ID__c,STU_ID__c=tms1.Name,Vendor_Code__c='E001');
            insert tr3;
            
            Training_Result__c tr4 = new Training_Result__c(Student_Training_Mapping__c=stm3.id,FFE_ID__c=studentthirdYear.FFE_ID__c,STU_ID__c=tms3.Name,Vendor_Code__c='I001');
            insert tr4;
            
            Training_Result__c tr5 = new Training_Result__c(Student_Training_Mapping__c=stm4.id,FFE_ID__c=studentfourthYear.FFE_ID__c,STU_ID__c=tms4.Name,Vendor_Code__c='MH001');
            insert tr5;
            
            Training_Result__c tr6 = new Training_Result__c(Student_Training_Mapping__c=stm5.id,FFE_ID__c=studentfourthYear.FFE_ID__c,STU_ID__c=tms5.Name,Vendor_Code__c='MT001');
            insert tr6;
            
            TrainingAndSkillDevelopment_CTRL.englishAndAptitudeAppData('English');
            TrainingAndSkillDevelopment_CTRL.englishAndAptitudeAppData('Aptitude');
            TrainingAndSkillDevelopment_CTRL.getThirdYearData('English');
            TrainingAndSkillDevelopment_CTRL.getThirdYearData('IT');
            TrainingAndSkillDevelopment_CTRL.getfourthYearData(system.label.Mock_Interview_HR);
            TrainingAndSkillDevelopment_CTRL.getfourthYearData(system.label.Mock_Interview_Tech);
            TrainingAndSkillDevelopment_CTRL.getSecondYearAspiringStudentData();
            TrainingAndSkillDevelopment_CTRL.getSecondYearDataLength();
            TrainingAndSkillDevelopment_CTRL.getThirdYearData_1();
            TrainingAndSkillDevelopment_CTRL.getfourthYearData_1();
            TrainingAndSkillDevelopment_CTRL.getSecondAspiringStdYearData();
            TrainingAndSkillDevelopment_CTRL.getThirdYearDataEnglisLength();
            TrainingAndSkillDevelopment_CTRL.getThirdYearApirationalLength();
            TrainingAndSkillDevelopment_CTRL.getPlacementStudentData();
            TrainingAndSkillDevelopment_CTRL.getMockinterViewRecordForThirdYear();
            TrainingAndSkillDevelopment_CTRL.getMockInterViewRecordDetailForThirdYear();
            TrainingAndSkillDevelopment_CTRL.getThirdYearDataLength();
            TrainingAndSkillDevelopment_CTRL.getFourthYearDataLength();
            
        }
    }
}