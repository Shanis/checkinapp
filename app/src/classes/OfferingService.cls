/*
* Offering service class to hold offering related functions
*
* @auther shanis.km@gmail.com
*
*/

public with sharing class OfferingService{    

    /*
    * Retrieves all offering with the Date today
    * limiting the query result by 200.
    */
    public List<Offering__c> getCurrentOffering(){
        return [Select Id,
                        Name,
                        Offering_Date__c, 
                        Offering_Subtype_c__c, 
                        Offering_Type__c, 
                        Point_Value__c, 
                        Instructor__r.Name
                        From Offering__c
                        Where Offering_Date__c = TODAY
                        Order By Offering_Date__c
                        LIMIT 200];
    }
    
    /*
    * Retrievs all offering irrespective of the offering date.
    * Limiting the query by 50000.
    * TODO: add pagination if the offering is growing exponentially.
    */
    public List<Offering__c> getAllOffering(){
        return [Select Id,
                        Name,
                        Offering_Date__c, 
                        Offering_Subtype_c__c, 
                        Offering_Type__c, 
                        Point_Value__c, 
                        Instructor__r.Name
                        From Offering__c
                        Order By Offering_Date__c
                        LIMIT 50000];
    }
}