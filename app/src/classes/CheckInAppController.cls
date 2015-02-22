/** 
* Controller for CheckInApp Page.
* Holds all the methods required for CheckInApp Page
*
* @auther shanis.km@gmail.com
*
*/

public with sharing class CheckInAppController{
    
    /** 
    * Method to get all the offering.
    * @return List of offering with start date today
    */
    @RemoteAction
    public static List<Offering__c> getOfferings(){
        OfferingService offeringService = new OfferingService();
        return offeringService.getCurrentOffering();
    }
    
    /** 
    * Method to get member details with provided memberId
    * return only 1 record. Assumption is memberId is unique.
    * @param member id
    * @return contact record
    */
    @RemoteAction
    public static Contact getMemberDetails(String memberId){
        MemberService memberService = new MemberService();
        return memberService.getContact(memberId);
    }

    /**
    * Method to create offering checkin attendance.
    * underlaying service is not bulkified for the fact that we can scan only one member at a time
    * Assumption here is memberId is unique and exists.
    * @param memberId scanned from qrcode
    * @param offeringId salesforce Id of offering
    * @param offering Sub type
    * @return response object with offering checkin status
    */
    @RemoteAction
    public static BaseService.Response memberOfferingCheckIn(String memberId, String offeringId, String offeringSubType){
        AttendanceService attService = new AttendanceService();
        return attService.createAttendance(memberId, offeringId, offeringSubType);
    }
    
    /**
    * Method to create check-in record
    * Creates check-in record, doesn't validate an checkin record without a checkout. 
    * @param memberId scanned from qrcode
    * @return response object with the status of the operation.
    */
    @RemoteAction
    public static BaseService.Response memberCheckIn(String memberId){
        CheckinService checkinService = new CheckinService();
        return checkinService.checkinMember(memberId);
    }
    
    /**
    * Method to create check-in check-out record
    * Update the checkin record with checkout info.
    * Returns false if there is no check-in record.
    * @param memberId scanned from qrcode
    * @return response object with the status of the operation.
    */
    @RemoteAction
    public static BaseService.Response memberCheckOut(String memberId){
        CheckinService checkinService = new CheckinService();
        return checkinService.checkOutMember(memberId);
    } 
}