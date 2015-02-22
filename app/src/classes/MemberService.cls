/**
* Member service class holds all the methods required for 
* member related functions
*
* @auther shanis.km@gmail.com
*
*/

public class MemberService extends BaseService{
    
    /**
    * Obtains the contact record with the member id provided
    * if duplicate member present with same id then the first member is returned
    * @param member id of the member
    * @return contact records
    */
    public Contact getContact(String memberId){
        Integer member_id = Integer.valueOf(memberId);
        List<Contact> contacts = [Select Id,
                                         Member_ID__c,
                                         MKP002__Photo_Id__c,
                                         FirstName,
                                         LastName,
                                         Pro_Kids_Level__c
                                         From Contact
                                         Where Member_ID__c = :member_id];
        
        if(contacts.size() == 0 || contacts == null){
            return null;
        }
        
        return contacts[0];
    }
    
    /**
    * Obtains member if of a member from salesforce contact id
    * @param contactId contacts salesforce Id
    * @returns String Member_Id
    */
    public String getMemberId(String contactId){
        List<Contact> contacts = [Select Id,
                                         Member_ID__c
                                         From Contact
                                         Where Id = :contactId];
        if(contacts.size() > 0 && contacts != null){
            return String.valueOf(contacts[0].Member_ID__c);
        }
        return null;                     
    }
}