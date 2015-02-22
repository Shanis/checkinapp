/**
* Check in Service Class to hold the methods related to CheckIn-Checkout object.
*
* @auther shanis.km@gmail.com
*
*/

public with sharing class CheckinService extends BaseService{
    
    private Response response;

    // constructor
    public CheckinService(){
        response = new Response();
    }

    /**
    * Check in member 
    * Operates only on single member at a time.
    * @param member id
    * @return response with status and message
    */
    public Response checkinMember(String memberId){
        return doCheckin(memberId);
    }
    
    /**
    * Check out member update existing check in record
    * fails if member don't have a checkin record
    * @param member id
    * @return response status and message
    */
    public Response checkOutMember(String memberId){
        List<Check_In_Out__c> checkInRecords = getCheckInRecords(memberId);
        if(checkInRecords.size() > 0 && checkInRecords != null){
           return doCheckOut(checkInRecords[0]);
        } else {
            response.setMessage(Label.CheckinApp_checkin_recordNotFound);
            response.setStatus(false);
            return response;
        }
    }
    
    /**
    * Validates the member checked in or not
    * @param member id
    * @return true if checked in else false
    */
    public Boolean isCheckedIn(String memberId){
        List<Check_In_Out__c> checkInRecords = getCheckInRecords(memberId);
        if(checkInRecords.size() > 0 && checkInRecords != null){
            return true;
        }
        return false;
    }

    /**
    * Obtains the list of check in out records for the provided member
    * return only the record which has check in date today and no checkout date
    * @param member id
    * @return List of check in/out record
    */
    private List<Check_In_Out__c> getCheckInRecords(String memberId){
      return [Select Id,
                      Member__c,
                      Check_In_Time__c,
                      Check_Out_Time__c,
                      Member_ID__c
                      From Check_In_Out__c
                      Where Member__c = :memberId
                      AND Check_Out_Time__c = null
                      AND Check_In_Time__c = TODAY];                                   
    }
    
    /**
    * Creates a check in record and inserts
    * @param member id
    * @returns response with status and message
    */
    private Response doCheckin(String memberId){
        if(isCheckedIn(memberId)){
            response.setMessage(Label.CheckinApp_checkin_alreadyCheckedIn);
            response.setStatus(false);
            return response;
        }

        MemberService memberService = new MemberService();
        Check_In_Out__c checkin = new Check_In_Out__c();
        checkin.Member__c = memberId;
        checkin.Check_In_Time__c = System.now();
        checkin.Member_ID__c = memberService.getMemberId(memberId);
        try{
            Database.insert(checkin, false);
            response.setMessage(Label.CheckinApp_checkin_success);
            response.setStatus(true);
            return response;
        } catch (DMLException ex){
            System.debug('>>> DML Exception : ' + ex);
            response.setMessage(Label.CheckinApp_checkin_failed);
            response.setStatus(false);
            return response;
        }   
    }

    /**
    * Updates checkinout record with checkout data
    * @param checkin record
    * @return response with status and message
    */
    private Response doCheckOut(Check_In_Out__c checkinRecord){
        checkinRecord.Check_Out_Time__c = System.now();
        try{
            Database.update(checkinRecord, false);
            response.setMessage(Label.CheckinApp_checkout_success);
            response.setStatus(true);
            return response;
        } catch (DMLException ex){
            System.debug('>>> DML Exception : ' + ex);
            response.setMessage(Label.CheckinApp_checkout_failed);
            response.setStatus(false);
            return response;
        }
    }
}