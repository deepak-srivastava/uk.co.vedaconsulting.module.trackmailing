{literal}
  <script type="text/javascript">
    cj(document).ready(function(){
      {/literal}
      var elem = '<tr class="crm-mailing-group-form-block-trackmailing-is-respect-optout">';
      elem += '<td class="label"> {$form.is_respect_optout.label}</td>';
      elem += '<td>{$form.is_respect_optout.html}';
      elem += '<div class="description">If the mailing is set as transactional then it will bypass the Communications Preferences of the recipient. Ensure that it meets the criteria for transactional mail.</div>';
      elem +=  '</tr>';
      {literal}
      cj(".crm-mailing-group-form-block-dedupeemail").after(elem);
    });
  </script>
{/literal}
