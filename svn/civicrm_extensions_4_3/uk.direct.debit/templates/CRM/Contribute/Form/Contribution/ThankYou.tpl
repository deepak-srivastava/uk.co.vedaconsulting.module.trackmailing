{*
 +--------------------------------------------------------------------+
 | CiviCRM version 4.1                                                |
 +--------------------------------------------------------------------+
 | Copyright CiviCRM LLC (c) 2004-2011                                |
 +--------------------------------------------------------------------+
 | This file is a part of CiviCRM.                                    |
 |                                                                    |
 | CiviCRM is free software; you can copy, modify, and distribute it  |
 | under the terms of the GNU Affero General Public License           |
 | Version 3, 19 November 2007 and the CiviCRM Licensing Exception.   |
 |                                                                    |
 | CiviCRM is distributed in the hope that it will be useful, but     |
 | WITHOUT ANY WARRANTY; without even the implied warranty of         |
 | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.               |
 | See the GNU Affero General Public License for more details.        |
 |                                                                    |
 | You should have received a copy of the GNU Affero General Public   |
 | License and the CiviCRM Licensing Exception along                  |
 | with this program; if not, contact CiviCRM LLC                     |
 | at info[AT]civicrm[DOT]org. If you have questions about the        |
 | GNU Affero General Public License or the licensing of CiviCRM,     |
 | see the CiviCRM license FAQ at http://civicrm.org/licensing        |
 +--------------------------------------------------------------------+
*}
{if $action & 1024}
    {include file="CRM/Contribute/Form/Contribution/PreviewHeader.tpl"}
{/if}

{include file="CRM/common/TrackingFields.tpl"}

<div class="crm-block crm-contribution-thankyou-form-block">
    {if $thankyou_text}
        <div id="thankyou_text" class="crm-section thankyou_text-section">
            {$thankyou_text}
        </div>
    {/if}
    
    {* Show link to Tell a Friend (CRM-2153) *}
    {if $friendText}
        <div id="tell-a-friend" class="crm-section friend_link-section">
            <a href="{$friendURL}" title="{$friendText}" class="button"><span>&raquo; {$friendText}</span></a>
       </div>{if !$linkText}<br /><br />{/if}
    {/if}  
    {* Add button for donor to create their own Personal Campaign page *}
    {if $linkText}
 	<div class="crm-section create_pcp_link-section">
        <a href="{$linkTextUrl}" title="{$linkText}" class="button"><span>&raquo; {$linkText}</span></a>
    </div><br /><br />
    {/if}  

    <div id="help">
        {* PayPal_Standard sets contribution_mode to 'notify'. We don't know if transaction is successful until we receive the IPN (payment notification) *}
        {if $is_pay_later}
	    <div class="bold">{$pay_later_receipt}</div>
	    {if $is_email_receipt}
                <div>
		    {if $onBehalfEmail AND ($onBehalfEmail neq $email)}		    
			{ts 1=$email 2=$onBehalfEmail}An email confirmation with these payment instructions has been sent to %1 and to %2.{/ts}
		    {else}
			{ts 1=$email}An email confirmation with these payment instructions has been sent to %1.{/ts}
		    {/if}
		</div>
            {/if}
        {elseif $contributeMode EQ 'notify' OR ($contributeMode EQ 'direct' && $is_recur) }
            {if $paymentProcessor.payment_type & 2}
                <div>{ts}That completes the setting up of your Direct Debit Instruction and the confirmation of the Instruction will be sent to you within 3 working days or be received by you no later than 10 working days before the first collection. Please print this page for your records.{/ts}</div>
            {else}
                <div>{ts 1=$paymentProcessor.processorName}Your contribution has been submitted to %1 for processing. Please print this page for your records.{/ts}</div>
            {/if}
            {if $is_email_receipt}
                <div>
		    {if $onBehalfEmail AND ($onBehalfEmail neq $email)}
			{ts 1=$email 2=$onBehalfEmail}An email receipt will be sent to %1 and to %2 once the transaction is processed successfully.{/ts}
		    {else}
			{ts 1=$email}An email receipt will be sent to %1 once the transaction is processed successfully.{/ts}
		    {/if}
		</div>
            {/if}
        {else}
            <div>{ts}Your transaction has been processed successfully. Please print this page for your records.{/ts}</div>
            {if $is_email_receipt}
                <div>		    
		    {if $onBehalfEmail AND ($onBehalfEmail neq $email)}
			{ts 1=$email 2=$onBehalfEmail}An email receipt has also been sent to %1 and to %2{/ts}		    
		    {else}
			{ts 1=$email}An email receipt has also been sent to %1{/ts}
		    {/if}
		</div>
            {/if}
        {/if}
    </div>
    <div class="spacer"></div>
    
    {include file="CRM/Contribute/Form/Contribution/MembershipBlock.tpl" context="thankContribution"}

    {if $amount GT 0 OR $minimum_fee GT 0 OR ( $priceSetID and $lineItem ) }
    <div class="crm-group amount_display-group">
       {if !$useForMember}
        <div class="header-dark">
            {if !$membershipBlock AND $amount OR ( $priceSetID and $lineItem )}{ts}Contribution Information{/ts}{else}{ts}Membership Fee{/ts}{/if}
        </div>
        {/if}
        <div class="display-block">
            {if !$useForMember}
            {if $lineItem and $priceSetID}
    	    {if !$amount}{assign var="amount" value=0}{/if}
    	    {assign var="totalAmount" value=$amount}
                {include file="CRM/Price/Page/LineItem.tpl" context="Contribution"}
            {elseif $membership_amount } 
                {$membership_name} {ts}Membership{/ts}: <strong>{$membership_amount|crmMoney}</strong><br />
                {if $amount}
                    {if ! $is_separate_payment }
    		    {ts}Contribution Amount{/ts}: <strong>{$amount|crmMoney}</strong><br />
    	        {else}
    		    {ts}Additional Contribution{/ts}: <strong>{$amount|crmMoney}</strong><br />
      	        {/if}
                {/if} 		
                <strong> -------------------------------------------</strong><br />
                {ts}Total{/ts}: <strong>{$amount+$membership_amount|crmMoney}</strong><br />
            {else}
                {ts}Amount{/ts}: <strong>{$amount|crmMoney} {if $amount_level } - {$amount_level} {/if}</strong><br />
            {/if}
	    {/if}
            {if $receive_date}
            {ts}Date{/ts}: <strong>{$receive_date|crmDate}</strong><br />
            {/if}
            {if $contributeMode ne 'notify' and $is_monetary and ! $is_pay_later and $trxn_id}
                {if $paymentProcessor.payment_type & 2}
                    {ts}Direct Debit Reference{/ts}: {$trxn_id}<br />
                {else}
                    {ts}Transaction #{/ts}: {$trxn_id}<br />
                {/if}
            {/if}
            {if $membership_trx_id}
    	    {ts}Membership Transaction #{/ts}: {$membership_trx_id}
            {/if}
        
            {* Recurring contribution / pledge information *}
            {if $is_recur}
                {if $membershipBlock} {* Auto-renew membership confirmation *}
                    <br />
                    <strong>{ts 1=$frequency_interval 2=$frequency_unit}This membership will be renewed automatically every %1 %2(s).{/ts}</strong>
                    <div class="description crm-auto-renew-cancel-info">({ts}You will be able to cancel automatic renewals at any time by logging in to your account or contacting us.{/ts})</div>
                {else}
                    {if $installments}
        		        <p><strong>{ts 1=$frequency_interval 2=$frequency_unit 3=$installments}This recurring contribution will be automatically processed every %1 %2(s) for a total %3 installments (including this initial contribution).{/ts}</strong></p>
                    {else}
                        <p><strong>{ts 1=$frequency_interval 2=$frequency_unit}This recurring contribution will be automatically processed every %1 %2(s).{/ts}</strong></p>
                    {/if}
                    <p>
            	    {if $contributeMode EQ 'notify'}
            		    {ts 1=$cancelSubscriptionUrl}You can modify or cancel future contributions at any time by <a href='%1'>logging in to your account</a>.{/ts}
            	    {/if}
            	    {if $contributeMode EQ 'direct'}
            		    {ts 1=$receiptFromEmail}To modify or cancel future contributions please contact us at %1.{/ts}
            	    {/if}
                    {if $is_email_receipt}
                        {ts}You will receive an email receipt for each recurring contribution.{/ts}
                    {/if}
            	    {if $contributeMode EQ 'notify'}
            		    {ts}The receipts will also include a link you can use if you decide to modify or cancel your future contributions.{/ts}
            	    {/if}
                    </p>
                {/if}
            {/if}
            {if $is_pledge}
                {if $pledge_frequency_interval GT 1}
                    <p><strong>{ts 1=$pledge_frequency_interval 2=$pledge_frequency_unit 3=$pledge_installments}I pledge to contribute this amount every %1 %2s for %3 installments.{/ts}</strong></p>
                {else}
                    <p><strong>{ts 1=$pledge_frequency_interval 2=$pledge_frequency_unit 3=$pledge_installments}I pledge to contribute this amount every %2 for %3 installments.{/ts}</strong></p>
                {/if}
                <p>
                {if $is_pay_later}
                    {ts 1=$receiptFromEmail}We will record your initial pledge payment when we receive it from you. You will be able to modify or cancel future pledge payments at any time by logging in to your account or contacting us at %1.{/ts}
                {else}
                    {ts 1=$receiptFromEmail}Your initial pledge payment has been processed. You will be able to modify or cancel future pledge payments at any time by logging in to your account or contacting us at %1.{/ts}
                {/if}
                {if $max_reminders}
                    {ts 1=$initial_reminder_day}We will send you a payment reminder %1 days prior to each scheduled payment date. The reminder will include a link to a page where you can make your payment online.{/ts}
                {/if}
                </p>
            {/if}
        </div>
    </div>
    {/if}
    
    {include file="CRM/Contribute/Form/Contribution/Honor.tpl"}

    {if $customPre}
            <fieldset class="label-left">
                {include file="CRM/UF/Form/Block.tpl" fields=$customPre}
            </fieldset>
    {/if}
    
    {if $pcpBlock}
    <div class="crm-group pcp_display-group">
        <div class="header-dark">
            {ts}Contribution Honor Roll{/ts}
        </div>
        <div class="display-block">
            {if $pcp_display_in_roll}
                {ts}List my contribution{/ts}
                {if $pcp_is_anonymous}
                    <strong>{ts}anonymously{/ts}.</strong>
                {else}
                    {ts}under the name{/ts}: <strong>{$pcp_roll_nickname}</strong><br/>
                    {if $pcp_personal_note}
                        {ts}With the personal note{/ts}: <strong>{$pcp_personal_note}</strong>
                    {else}
                     <strong>{ts}With no personal note{/ts}</strong>
                     {/if}
                {/if}
            {else}
		        {ts}Don't list my contribution in the honor roll.{/ts}
            {/if}
            <br />
       </div>
    </div>
    {/if}
    
    {if $onbehalfProfile}
      <div class="crm-group onBehalf_display-group">
         {include file="CRM/UF/Form/Block.tpl" fields=$onbehalfProfile}
         <div class="crm-section organization_email-section">
            <div class="label">{ts}Organization Email{/ts}</div>
            <div class="content">{$onBehalfEmail}</div>
            <div class="clear"></div>
         </div>
      </div>
    {/if}
    
    {if $contributeMode ne 'notify' and ! $is_pay_later and $is_monetary and ( $amount GT 0 OR $minimum_fee GT 0 )}    
    <div class="crm-group billing_name_address-group">
        <div class="header-dark">
            {ts}Billing Name and Address{/ts}
        </div>
    	<div class="crm-section no-label billing_name-section">
    		<div class="content">{$billingName}</div>
    		<div class="clear"></div>
    	</div>
    	<div class="crm-section no-label billing_address-section">
    		<div class="content">{$address|nl2br}</div>
    		<div class="clear"></div>
    	</div>
        <div class="crm-section no-label contributor_email-section">
        	<div class="content">{$email}</div>
        	<div class="clear"></div>
        </div>
    </div>
    {/if}

    {if $contributeMode eq 'direct' and ! $is_pay_later and $is_monetary and ( $amount GT 0 OR $minimum_fee GT 0 )}
    <div class="crm-group credit_card-group">
         {if $paymentProcessor.payment_type & 2}
            <div class="header-dark">
            {ts}Direct Debit Information{/ts}
            </div>
            <div>{ts}Thank you very much for your Direct Debit Instruction details. Below is the Direct Debit Guarantee for your information.{/ts}</div>
         {else}
            <div class="header-dark">
            {ts}Credit Card Information{/ts}
            </div>
         {/if}
        </div>
         {if $paymentProcessor.payment_type & 2}
                <div class="display-block">
                    <table>
                    <tr><td>{ts}Account Holder{/ts}:</td><td>{$account_holder}</td>
                        <td rowspan="6">
                            <table width="100%" border="0" cellpadding="5" cellspacing="5">
                                <tr>
                                    <td><strong>Service User Number</strong></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table>
                                            <tr>
                                                <td><input size="1" maxlength="1" style="width:20px;" name="txtOrigID1" type="text" value="9" disabled="true"></td>
                                                <td><input size="1" maxlength="1" style="width:20px;" name="txtOrigID2" type="text" value="7" disabled="true"></td>
                                                <td><input size="1" maxlength="1" style="width:20px;" name="txtOrigID3" type="text" value="1" disabled="true"></td>
                                                <td><input size="1" maxlength="1" style="width:20px;" name="txtOrigID4" type="text" value="9" disabled="true"></td>
                                                <td><input size="1" maxlength="1" style="width:20px;" name="txtOrigID5" type="text" value="2" disabled="true"></td>
                                                <td><input size="1" maxlength="1" style="width:20px;" name="txtOrigID6" type="text" value="2" disabled="true"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <small><b>Islington Council</b><br>
                                        Council Tax<br>
                                        PO Box 34750<br>
                                        London<br>
                                        N7 9WF</small>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                </tr>
                            </table>
                        </td></tr>
                    <tr><td>{ts}Bank Account Number{/ts}:</td><td>{$bank_account_number}</td></tr>
                    <tr><td>{ts}Bank Identification Number{/ts}:</td><td>{$bank_identification_number}</td></tr>
                    <tr><td>{ts}Bank Name{/ts}:</td><td>{$direct_debit_details.bank_name}</td></tr>
                    <tr><td>{ts}Branch{/ts}:</td><td>{$direct_debit_details.branch}</td></tr>
                    <tr><td>{ts}Address{/ts}:</td><td>{$direct_debit_details.address1}, {$direct_debit_details.address2}, {$direct_debit_details.address3}, {$direct_debit_details.address4}, {$direct_debit_details.town}, {$direct_debit_details.county}, {$direct_debit_details.postcode}</td></tr>
                    </table>
   <TABLE WIDTH="620" CELLPADDING="2" CELLSPACING="0" BORDER="1" RULES="NONE">
    <TR>
     <TD WIDTH="580" VALIGN=TOP>
      <P ALIGN=CENTER>
       <FONT FACE="Arial,Helvetica,Monaco"><FONT SIZE="5"><B>The Direct Debit Guarantee</B></FONT><FONT SIZE="6"> </FONT></FONT><!-- $MVD$:picsz("894","306") --><IMG SRC="ddlogo.gif" ALIGN=TOP WIDTH="107" HEIGHT="37" VSPACE="0" HSPACE="0" ALT="direct debit logo" BORDER="0" LOOP="0"></TD>
     <TD WIDTH="20" VALIGN=TOP></TD>
    </TR>
    <TR>
     <TD WIDTH="94%" VALIGN=TOP>
      <P ALIGN=LEFT>
       <FONT FACE="Arial,Helvetica,Monaco"><FONT SIZE="3">&#149;</FONT><FONT SIZE="1"> 
       {ts}The Guarantee is offered by all Banks and Building Societies that take part in the Direct Debit Scheme. The efficiency and security of the Scheme is monitored and protected by your own Bank or Building Society.{/ts}
       </FONT></FONT><BR>
       <FONT FACE="Arial,Helvetica,Monaco"><FONT SIZE="3">&#149;</FONT><FONT SIZE="1"> 
       {ts}If the amounts to be paid or the payment dates change FrancoBritish Society will notify you at least 10 working days in advance of your account being debited or as otherwise agreed.{/ts}
       </FONT></FONT><BR>
       <FONT FACE="Arial,Helvetica,Monaco"><FONT SIZE="3">&#149;</FONT><FONT SIZE="1"> 
       {ts}If an error is made by FrancoBritish Society or your Bank or Building Society you are guaranteed a full and immediate refund from your branch of the amount paid.{/ts}
       </FONT></FONT><BR>
       <FONT FACE="Arial,Helvetica,Monaco"><FONT SIZE="3">&#149; </FONT><FONT SIZE="1">
       {ts}You can cancel a Direct Debit at any time by writing to your Bank or Building Society. Please also send a copy of your letter to us.{/ts}
       </FONT></FONT></TD>
     <TD WIDTH="20" VALIGN=TOP></TD>
    </TR>
   </TABLE>
                </div>

         {else}
             <div class="crm-section no-label credit_card_details-section">
                 <div class="content">{$credit_card_type}</div>
             	<div class="content">{$credit_card_number}</div>
             	<div class="content">{ts}Expires{/ts}: {$credit_card_exp_date|truncate:7:''|crmDate}</div>
             	<div class="clear"></div>
             </div>
         {/if}
    </div>
    {/if}

    {include file="CRM/Contribute/Form/Contribution/PremiumBlock.tpl" context="thankContribution"}

    {if $customPost}
            <fieldset class="label-left">
                {include file="CRM/UF/Form/Block.tpl" fields=$customPost}
            </fieldset>
    {/if}

    <div id="thankyou_footer" class="contribution_thankyou_footer-section">
        <p>
        {$thankyou_footer}
        </p>
    </div>
    {if $isShare}
    {capture assign=contributionUrl}{crmURL p='civicrm/contribute/transact' q="$qParams" a=true fe=1 h=1}{/capture}
    {include file="CRM/common/SocialNetwork.tpl" url=$contributionUrl title=$title pageURL=$contributionUrl}
    {/if}
</div>
