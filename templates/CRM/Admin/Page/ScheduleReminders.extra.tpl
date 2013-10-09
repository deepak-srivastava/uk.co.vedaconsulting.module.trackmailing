{literal}
  <script type="text/javascript">
    var trackmail = cj("#trackMail").attr('checked');
    cj(document).ready(function(){
      cj("#trackMail").parents('tr').insertAfter("#recipientList");
      cj("#trackMail").parents('tr').attr('id', 'track_mailing');
      cj("#view_mailing_report").insertAfter("#trackMail");
      cj("#mailing_job").parents('tr').insertAfter("#track_mailing");
      cj("#subject").val('Not using Mailing Job');
           
      if( trackmail == 'checked'){
        cj("#compose_id").hide();
      }else{
        cj("#mailing_job").parents('tr').hide();
      }
    });
      cj("#trackMail").change(function(){
        if(cj(this).is(':checked')){
          cj("#mailing_job").parents('tr').show();
          cj("#compose_id").hide();
        }else{
          cj("#mailing_job").parents('tr').hide();
          cj("#compose_id").show();
        }
         
      });
  </script>
{/literal}