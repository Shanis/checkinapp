/** 
* Base class for services. All common methods used for services goes here.
*
* @auther shanis.km@gmail.com
*
*/

public abstract class BaseService{
    
    /**  
    * Analyzes bulk inserts overall results.
    * It says is there any failure or not. It's caller's responsibility to get the details of each 
    * failure and taking the appropriate action.
    * @param database save results.
    * @return Boolean return true if all insert or update result is successful. return false even for a single failure.
    */
    public boolean completeStatus(Database.SaveResult[] results){
        Boolean status = true;
        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                status = false;             
                for(Database.Error err : result.getErrors()) {                   
                    System.debug(err.getStatusCode() + ': ' + err.getMessage() + ': ' + err.getFields());
                }
            }
        }
        return status;
    }

    /**
    * response data transfer object to hold response data
    */
    public class Response{
        private String message;
        private Boolean status;

        public void setMessage(String message){
            this.message = message;
        }

        public void setStatus(Boolean status){
            this.status = status;
        }
    }
}