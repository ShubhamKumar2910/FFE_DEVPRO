public class DocumentUploadCLs{
    public List<DocRecordCls> docWrapperRecordList {get;set;}
    public String currentRecordId {get;set;}
    public Contact con{get;set;}
    public Boolean isDisplay{get;set;}

    public DocumentUploadCLs(){
        isDisplay = False;
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
    
        con = [select id,name,Letter_of_Thanks_to_Donors__c,Oath_Pledge_and_Declaration_Form_signed__c,Odd_Semester_Mark_Sheet_of_the_previous__c,Even_Semester_Mark_Sheet_of_the_previous__c,Entrance_Test_Marks_Rank_Certificate__c,Parents_or_Guardians_Declaration__c,PUC_12th_Marks_Sheet__c,Bonafide_Student_Certificate__c,Admission_or_Seat_Allotment_Letter__c,Copy_of_First_Sheet_of_Bank_Pass_Book__c,Income_Salary_Certificate__c,Statement_of_Estimated_Expenses_for_FY__c,Receipts_for_Actual_Expenses__c, Applicant_s_Pledge_of_Future_Support__c,Marks_Sheet_for_10th_Standard__c,Declaration_Form_Donorview__c from contact where id =: currentRecordId ];
    
        List<String> docList= new List<String>();
        docList.add('Mark Sheet for Secondary School Certificate (10th) Board Examination');
        docList.add('Mark Sheet for Higher Secondary (12th/PUC/Intermediate) Examination');
        docList.add('Entrance Test Marks & Rank Certificate');
        docList.add('Counselling, Admission or Seat Allotment Letter');
        docList.add('Income Certificate, Salary Certificate, Pension Certificate or Income Tax Return or Other document, as applicable');
        docList.add('Bonafide Student Certificate showing status of enrolment in college, course/branch, year of study');
        docList.add('Receipts for Actual Expenses incurred for current year(College Fee/Hostel & Mess/Transport/Books/Uniform');
        docList.add('Statement of Estimated Expenses for the current academic year Issued by your College');
        docList.add('Copy of First Sheet of Bank Pass Book or Cancelled Cheque');
        docList.add('Applicants Pledge of Future Support to FFE');
        docList.add('Parent or Guardians Declaration');
        docList.add('Even Semester Mark Sheet of the previous academic year');
        docList.add('Odd Semester Mark Sheet of the previous year');
        docList.add('Declaration Form');
        //docList.add('Oath, Pledge and Declaration Form signed by you and your parent/guardian');
        //  docList.add('Letter of Thanks to Donors');
        docWrapperRecordList = new List<DocRecordCls>();
   
        if(!docList.isEmpty()) {
            for(String acc: docList){
                DocRecordCls arcls = new DocRecordCls();
                if(acc.contains('Actual Expenses incurred for current')){
                    if(con.Receipts_for_Actual_Expenses__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim / Renewal';
                }
                if(acc.contains('Pledge of Future')){
                    if(con.Applicant_s_Pledge_of_Future_Support__c == true){
                       arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim / Renewal';
                }
                if(acc == 'Mark Sheet for Secondary School Certificate (10th) Board Examination'){
                    if(con.Marks_Sheet_for_10th_Standard__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim';
                }
                if(acc == 'Income Certificate, Salary Certificate, Pension Certificate or Income Tax Return or Other document, as applicable'){
                    if(con.Income_Salary_Certificate__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim';
                }
                if(acc.contains('Statement of Estimated Expenses')){
                    if(con.Statement_of_Estimated_Expenses_for_FY__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim / Renewal';
                }
                if(acc.contains('Copy of First Sheet')){
                    if(con.Copy_of_First_Sheet_of_Bank_Pass_Book__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim / Renewal';
                }
                if(acc == 'Counselling, Admission or Seat Allotment Letter'){
                    if(con.Admission_or_Seat_Allotment_Letter__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim';
                }
                if(acc.contains('Bonafide Student Certificate')){
                    if(con.Bonafide_Student_Certificate__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim / Renewal';
                }
                if(acc == 'Mark Sheet for Higher Secondary (12th/PUC/Intermediate) Examination'){
                    if(con.PUC_12th_Marks_Sheet__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim';
                }
                if(acc == 'Parent or Guardians Declaration'){
                    if(con.Parents_or_Guardians_Declaration__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim / Renewal';
                }
                if(acc.contains('Entrance Test Marks')){
                    if(con.Entrance_Test_Marks_Rank_Certificate__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim';
                }
                if(acc.contains('Even Semester Mark Sheet')){
                    if(con.Even_Semester_Mark_Sheet_of_the_previous__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Renewal';
                }
                if(acc.contains('Odd Semester Mark Sheet')){
                    if(con.Odd_Semester_Mark_Sheet_of_the_previous__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Renewal';
                }
                if(acc.contains('Declaration Form')){
                    if(con.Declaration_Form_Donorview__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim / Renewal';
                }   
                
                arcls.docObj = acc;
                docWrapperRecordList.add(arcls);
                isDisplay = True;
            } //end of for loop.

        } //end of if condition.
    }
 
    public PageReference Submit(){
      
        Set<String> accToDelete = new Set<String>();
      
        List<DocRecordCls> listUnSelectedRecords  = new List<DocRecordCls>();  
        if(docWrapperRecordList !=null && docWrapperRecordList.size()>0) {
            for(DocRecordCls wrapObj :  docWrapperRecordList){
                if(wrapObj.isSelected == true){
                    accToDelete.add(wrapObj.docObj);
                }else{
                    listUnSelectedRecords.add(wrapObj);
                }
            }//end of for.
          
            system.debug('@@1 '+accToDelete);
            system.debug('@@2 '+listUnSelectedRecords);
            /*
            checking the delete list size and assign the unselected values to 
            original wrapper list.
            */
            if((accToDelete !=null && accToDelete.size()>0) || (listUnSelectedRecords !=null && listUnSelectedRecords.size()>0)){
                if(accToDelete.contains('Receipts for Actual Expenses incurred for current year(College Fee/Hostel & Mess/Transport/Books/Uniform')){
                    con.Receipts_for_Actual_Expenses__c = True;
                }else{
                    con.Receipts_for_Actual_Expenses__c = False; 
                }
                if(accToDelete.contains('Applicants Pledge of Future Support to FFE')){
                    con.Applicant_s_Pledge_of_Future_Support__c = True;
                }else{
                    con.Applicant_s_Pledge_of_Future_Support__c = False; 
                }
                if(accToDelete.contains('Mark Sheet for Secondary School Certificate (10th) Board Examination')){
                    con.Marks_Sheet_for_10th_Standard__c = True;
                }else{
                    con.Marks_Sheet_for_10th_Standard__c = False; 
                }
                if(accToDelete.contains('Income Certificate, Salary Certificate, Pension Certificate or Income Tax Return or Other document, as applicable')){
                    con.Income_Salary_Certificate__c = True;
                }else{
                    con.Income_Salary_Certificate__c = False; 
                }
                if(accToDelete.contains('Statement of Estimated Expenses for the current academic year Issued by your College')){
                    con.Statement_of_Estimated_Expenses_for_FY__c = True;
                }else{
                    con.Statement_of_Estimated_Expenses_for_FY__c = False; 
                }
                if(accToDelete.contains('Copy of First Sheet of Bank Pass Book or Cancelled Cheque')){
                    con.Copy_of_First_Sheet_of_Bank_Pass_Book__c = True;
                }else{
                    con.Copy_of_First_Sheet_of_Bank_Pass_Book__c = False; 
                }
                if(accToDelete.contains('Counselling, Admission or Seat Allotment Letter')){
                    con.Admission_or_Seat_Allotment_Letter__c = True;
                }else{
                    con.Admission_or_Seat_Allotment_Letter__c = False; 
                }
                if(accToDelete.contains('Bonafide Student Certificate showing status of enrolment in college, course/branch, year of study')){
                    con.Bonafide_Student_Certificate__c = True;
                }else{
                    con.Bonafide_Student_Certificate__c = False; 
                }
                if(accToDelete.contains('Mark Sheet for Higher Secondary (12th/PUC/Intermediate) Examination')){
                    con.PUC_12th_Marks_Sheet__c = True;
                }else{
                    con.PUC_12th_Marks_Sheet__c = False; 
                }
                if(accToDelete.contains('Parent or Guardians Declaration')){
                    con.Parents_or_Guardians_Declaration__c = True;
                }else{
                    con.Parents_or_Guardians_Declaration__c = False; 
                }
                if(accToDelete.contains('Entrance Test Marks & Rank Certificate')){
                    con.Entrance_Test_Marks_Rank_Certificate__c = True;
                }else{
                    con.Entrance_Test_Marks_Rank_Certificate__c = False; 
                }
                if(accToDelete.contains('Even Semester Mark Sheet of the previous academic year')){
                    con.Even_Semester_Mark_Sheet_of_the_previous__c = True;
                }else{
                    con.Even_Semester_Mark_Sheet_of_the_previous__c = False; 
                }
                 if(accToDelete.contains('Declaration Form')){
                    con.Declaration_Form_Donorview__c = true;
                }else{
                    con.Declaration_Form_Donorview__c = false;
                }
                if(accToDelete.contains('Odd Semester Mark Sheet of the previous year')){
                    con.Odd_Semester_Mark_Sheet_of_the_previous__c = True;
                }else{
                    con.Odd_Semester_Mark_Sheet_of_the_previous__c = False; 
                }
                
                update con;
           
                system.debug('@@ '+con.Receipts_for_Actual_Expenses__c);
           
                //Commented the below code as a part of change of design to show the documents to the donor  -- Sumit Gaurav  20-05-2020
                /*  List<Id> StudentId = new List<Id>();

                List<Donor_Application_Mapping__c> DonorApp = [Select Id,Student__c From Donor_Application_Mapping__c where Donor__c = :con.id];
                for(Donor_Application_Mapping__c DA : DonorApp){
                    StudentId.add(DA.Student__c);
                }
           
                List<Contact> ContactList = [Select Id,Name,Letter_of_Thanks_to_Donors__c,Oath_Pledge_and_Declaration_Form_signed__c,Odd_Semester_Mark_Sheet_of_the_previous__c,Even_Semester_Mark_Sheet_of_the_previous__c,Entrance_Test_Marks_Rank_Certificate__c,Parents_or_Guardians_Declaration__c,PUC_12th_Marks_Sheet__c,Bonafide_Student_Certificate__c,Admission_or_Seat_Allotment_Letter__c,Copy_of_First_Sheet_of_Bank_Pass_Book__c,Income_Salary_Certificate__c,Statement_of_Estimated_Expenses_for_FY__c,Receipts_for_Actual_Expenses__c, Applicant_s_Pledge_of_Future_Support__c,Marks_Sheet_for_10th_Standard__c From Contact where Id IN :StudentId];
                for(Contact c:ContactList){
                    c.Receipts_for_Actual_Expenses__c = con.Receipts_for_Actual_Expenses__c;
                    c.Applicant_s_Pledge_of_Future_Support__c = con.Applicant_s_Pledge_of_Future_Support__c;
                    c.Marks_Sheet_for_10th_Standard__c = con.Marks_Sheet_for_10th_Standard__c;
                    c.Income_Salary_Certificate__c = con.Income_Salary_Certificate__c;
                    c.Statement_of_Estimated_Expenses_for_FY__c = con.Statement_of_Estimated_Expenses_for_FY__c;
                    c.Copy_of_First_Sheet_of_Bank_Pass_Book__c = con.Copy_of_First_Sheet_of_Bank_Pass_Book__c;
                    c.Admission_or_Seat_Allotment_Letter__c = con.Admission_or_Seat_Allotment_Letter__c;
                    c.Bonafide_Student_Certificate__c = con.Bonafide_Student_Certificate__c;
                    c.PUC_12th_Marks_Sheet__c = con.PUC_12th_Marks_Sheet__c;
                    c.Parents_or_Guardians_Declaration__c = con.Parents_or_Guardians_Declaration__c;
                    c.Entrance_Test_Marks_Rank_Certificate__c = con.Entrance_Test_Marks_Rank_Certificate__c;
                    c.Even_Semester_Mark_Sheet_of_the_previous__c = con.Even_Semester_Mark_Sheet_of_the_previous__c;
                    c.Odd_Semester_Mark_Sheet_of_the_previous__c = con.Odd_Semester_Mark_Sheet_of_the_previous__c;
                    c.Oath_Pledge_and_Declaration_Form_signed__c = con.Oath_Pledge_and_Declaration_Form_signed__c;
                    // c.Letter_of_Thanks_to_Donors__c = con.Letter_of_Thanks_to_Donors__c;
                }
          
                update ContactList; */
          
                // docWrapperRecordList.clear();
                // docWrapperRecordList.addAll(listUnSelectedRecords);
            }
          
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'List of Documents of scholars for Donor to View are now Selected!'));
            isDisplay = false;
        
        }else{
            ApexPages.Message  myMsg = new ApexPages.Message(ApexPages.Severity.info, 'Records were not there to delete.');
            ApexPages.addMessage(myMsg);
            isDisplay =  False;
        }
      
        return null;
    }
  

    /* Wrapper class with checkbox and account object. 
      this is also  called as inner class 
    */
    public class DocRecordCls{
        public boolean isSelected {get;set;}
        public String docrelated {get;set;}
        public String docObj {get;set;}

    }

}