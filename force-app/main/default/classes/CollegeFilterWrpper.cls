/*
* @Purpose		: This Wrapper class is used to hold filter criteria for searching Students.
* @Author		: Gayathri
* @CreatedDate  : 17/02/2016
*/
  public class CollegeFilterWrpper {
      
      public List<string> studentState;
      public List<string> collegStates;
      public List<string> collegeCity;
      public List<string> collegeName;
      public List<string> Course;
      public List<string> collegeRating;
      public List<string> genderList;
      public List<string> branchList;
      public double minIncome;
      public double maxIncome;  
      public String FFEUId;
      public List<String> courseYear;
    // public String examNameList;
    // public String ExamRankList;
      public String ScholarshipAmountList;
      public String priorityList;
   
      public collegeFilterWrpper()
      {
         studentState  			=   new  List<string>();
         collegStates  			=   new  List<string>();
         collegeCity   			=   new  List<string>(); 
         collegeName   			=   new  List<string>();
         Course        			=   new  List<string>();
         collegeRating 			=   new  List<string>();
         genderList	   			=   new  List<string>();
         branchList	   			=   new  List<string>();	
         FFEUId        			=   '';
         courseYear    			=   new  List<String>();
      // examNameList  			=   '';
      // ExamRankList  			=   '';
         ScholarshipAmountList  =   '';
         priorityList 				=   ''; 
          
      }
  
}