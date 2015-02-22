/** 
* Attendance Service class holds all the methods related to offering attandance.
*
* @auther shanis.km@gmail.com
*
*/

public class AttendanceService extends BaseService{
    private Response response;
    public AttendanceService(){
        response = new Response();
    }

    /** 
    * Method to create attendace object with provided memberId and offeringId
    * Assumption here is that you create only 1 attendance with this method.
    * If you need to bulk insert utilize bulkCreateAttendance method.
    * @param memberId saleforce Id of member contact
    * @param offeringId salesforce Id of offering record
    * @return Boolean status of the insert.
    */
    public Response createAttendance(String memberId, String offeringId, String offeringSubType){
        if(!validateMemberCheckedIn(memberId)){
            response.setMessage(Label.CheckinApp_attendance_notCheckedIn);
            response.setStatus(false);
            return response;
        }

        if(hasValidAttendance(memberId, offeringId)){
            response.setMessage(Label.CheckinApp_attendance_hasAttendance);
            response.setStatus(false);
            return response;
        }

        Attendance__c attendance = new Attendance__c();
        attendance.Name = offeringSubType;
        attendance.Member__c = memberId;
        attendance.Offering__c = offeringId;
        List<Attendance__c> attendances = new List<Attendance__c>();
        attendances.add(attendance);
        if(bulkCreateAttendance(attendances)){
            response.setMessage(Label.CheckinApp_attendance_success);
            response.setStatus(true);
        } else {
            response.setMessage(Label.CheckinApp_attendance_failure);
            response.setStatus(false);
        }
        return response;
    }
    
    /** 
    * Method to create attendance record in bulk.
    * Client is responsible for taking the necessary action if there is a failure.
    * Here all or none is true for the insert operation.
    * @param list of attandance object
    * @return Boolean status of the insert option.
    */
    public Boolean bulkCreateAttendance(List<Attendance__c> attendances ){
        Database.SaveResult[] results = Database.insert(attendances, true);
        return completeStatus(results);
    }
    
    /**
    * Method to validate the member scanning for offering is checked in
    * @param memberId
    * @return Boolean returns true if the member is checkedin else false
    */
    private Boolean validateMemberCheckedIn(String memberId){
        CheckInService checkinService = new CheckInService();
        return checkinService.isCheckedIn(memberId);
    }

    /**
    * Validates the member has a valid attendance for the provided offering
    * @param member id
    * @param offering id
    * @return true if attandance exists else false
    */
    private Boolean hasValidAttendance(String memberId, String offeringId){
        List<Attendance__c> attendances = [Select Id 
                                            from Attendance__c 
                                            Where Offering__c = :offeringId 
                                            And Member__c = :memberId];
        if(attendances.size() > 0){
            return true;
        }

        return false;
    }
}