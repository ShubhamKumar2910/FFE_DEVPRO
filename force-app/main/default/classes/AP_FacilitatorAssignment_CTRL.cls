/*
* @Purpose      :  FacilitatorAssignment_CTRL class.
* @Author       :  Supriya Chakrapani
* @CreatedDate  :  22-03-2017
*/

public class AP_FacilitatorAssignment_CTRL{
    public string listOfStates          {get;set;}
    
    
   public AP_FacilitatorAssignment_CTRL(){
        listOfStates          = JSON.serializePretty(Utility.getStates(Constants.COUNTRY_IND));
    }
    
    @RemoteAction
    public static string getCities(string currentState){
        return JSON.serializePretty(AP_FacilitatorAssignment_helper.getAllCities(currentState));
    }
    
    @RemoteAction
    public static String getStudentDetails(String state,String city,String addressType){
        return JSON.serializePretty(AP_FacilitatorAssignment_Helper.getStudentDetails(state,city,addressType));
        
    }
    
    @RemoteAction
    public static String getFacilitatorDetails(String state,String city){
        return JSON.serializePretty(AP_FacilitatorAssignment_Helper.getFacilitatorDetails(state,city));
        
    }
    
    @RemoteAction
    public static String createFacilitatorMapping(List<facilitatorStudentWrapper> facilitatorStudentList){
        return AP_FacilitatorAssignment_Helper.createFacilitatorMapping(facilitatorStudentList);
    }
    
    //Wrapper for passing student and facilitator Id
    public class facilitatorStudentWrapper {
        public String studentId;
        public String facilitatorId;
        
        public facilitatorStudentWrapper(){
            studentId  = '';
            facilitatorId= '';
        }
    }
}