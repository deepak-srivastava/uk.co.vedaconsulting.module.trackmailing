<?php

/*
 +--------------------------------------------------------------------+
 | CiviCRM version 3.1                                                |
 +--------------------------------------------------------------------+
 | Copyright CiviCRM LLC (c) 2004-2010                                |
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
*/

/**
 *
 * @package CRM
 * @copyright CiviCRM LLC (c) 2004-2010
 * $Id$
 *
 */

/**
 * This class generates form components for processing Event  
 * 
 */
require_once 'CRM/Core/Form.php';
require_once 'CRM/Core/BAO/Setting.php';

class UK_Direct_Debit_Form_Main extends CRM_Core_Form
{
  CONST
    SETTING_GROUP_UK_DD_NAME = 'UK Direct Debit'
   ,DD_SIGN_UP_ACITIVITY_TYPE_ID = 46; /* TODO get this from DB based on civicrm setting?. Also needs creating on Install */

  function rand_str( $len )
  {
    // The alphabet the random string consists of
    $abc = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    // The default length the random key should have
    $defaultLength = 3;

    // Ensure $len is a valid number
    // Should be less than or equal to strlen( $abc ) but at least $defaultLength
    $len = max( min( intval( $len ), strlen( $abc )), $defaultLength );

    // Return snippet of random string as random string
    return substr( str_shuffle( $abc ), 0, $len );
  }
  
  function getDDIReference() {
      
    $DDIReference = self::rand_str(16);
      
    return $DDIReference;
  }
  
  function getCompanyName() {
      
    $companyName = CRM_Core_BAO_Setting::getItem(self::SETTING_GROUP_UK_DD_NAME,'company_name');
    return $companyName;
  }
  
  /** create all fields needed for direct debit transaction
   *
   * @return void
   * @access public
   */
  function setDirectDebitFields(&$form) {
 //   CRM_Core_Payment_Form::_setPaymentFields($form);

    $form->_paymentFields['account_holder'] = array(
      'htmlType' => 'text',
      'name' => 'account_holder',
      'title' => ts('xxxAccount Holder'),
      'cc_field' => TRUE,
      'attributes' => array('size' => 20, 'maxlength' => 34, 'autocomplete' => 'on'),
      'is_required' => TRUE,
    );

    //e.g. IBAN can have maxlength of 34 digits
    $form->_paymentFields['bank_account_number'] = array(
      'htmlType' => 'text',
      'name' => 'bank_account_number',
      'title' => ts('xxxxBank Account Number'),
      'cc_field' => TRUE,
      'attributes' => array('size' => 20, 'maxlength' => 34, 'autocomplete' => 'off'),
      'is_required' => TRUE,
    );

    //e.g. SWIFT-BIC can have maxlength of 11 digits
    $form->_paymentFields['bank_identification_number'] = array(
      'htmlType' => 'text',
      'name' => 'bank_identification_number',
      'title' => ts('Bank Identification Number'),
      'cc_field' => TRUE,
      'attributes' => array('size' => 20, 'maxlength' => 11, 'autocomplete' => 'off'),
      'is_required' => TRUE,
    );

    $form->_paymentFields['bank_name'] = array(
      'htmlType' => 'text',
      'name' => 'bank_name',
      'title' => ts('Bank Name'),
      'cc_field' => TRUE,
      'attributes' => array('size' => 20, 'maxlength' => 64, 'autocomplete' => 'off'),
      'is_required' => TRUE,
    );

    // Get the collection days options
    require_once 'UK_Direct_Debit/Form/Main.php';
    $collectionDaysArray = UK_Direct_Debit_Form_Main::getCollectionDaysOptions(); 
    
    $form->_paymentFields['preferred_collection_day'] = array(
      'htmlType' => 'select',
      'name' => 'preferred_collection_day',
      'title' => ts('Preferred Collection Day'),
      'cc_field' => TRUE,
      'attributes' => $collectionDaysArray, // array('1' => '1', '8' => '8', '21' => '21'),
      'is_required' => TRUE,
    );
    
    $form->_paymentFields['confirmation_method'] = array(
      'htmlType' => 'select',
      'name' => 'confirmation_method',
      'title' => ts('Confirm By'),
      'cc_field' => TRUE,
      'attributes' => array('EMAIL' => 'Email', 'POST' => 'Post'),
      'is_required' => TRUE,
    );
    
    $form->_paymentFields['ddi_reference'] = array(
      'htmlType' => 'text',
      'name' => 'ddi_reference',
      'title' => ts('DDI Reference'),
     'cc_field' => TRUE,
      'attributes' => array('size' => 20, 'maxlength' => 64, 'autocomplete' => 'off'),
      'is_required' => FALSE,
      'default' => 'hello'
    );
    
  }

  /**
   * Function to add all the direct debit fields
   *
   * @return None
   * @access public
   */
  function buildDirectDebit(&$form, $useRequired = FALSE) {
    if ($form->_paymentProcessor['billing_mode'] & CRM_Core_Payment::BILLING_MODE_FORM) {
      self::setDirectDebitFields($form);
      foreach ($form->_paymentFields as $name => $field) {
        if (isset($field['cc_field']) &&
          $field['cc_field']
        ) {
          $form->add($field['htmlType'],
            $field['name'],
            $field['title'],
            $field['attributes'],
            $useRequired ? $field['is_required'] : FALSE
          );
        }
      }

      $form->addRule('bank_identification_number',
        ts('Please enter a valid Bank Identification Number (value must not contain punctuation characters).'),
        'nopunctuation'
      );

      $form->addRule('bank_account_number',
        ts('Please enter a valid Bank Account Number (value must not contain punctuation characters).'),
        'nopunctuation'
      );
    }

    if ($form->_paymentProcessor['billing_mode'] & CRM_Core_Payment::BILLING_MODE_BUTTON) {
      $form->_expressButtonName = $form->getButtonName($form->buttonType(), 'express');
      $form->add('image',
        $form->_expressButtonName,
        $form->_paymentProcessor['url_button'],
        array('class' => 'form-submit')
      );
    }
     
    $defaults['ddi_reference'] = self::getDDIReference();
    $form->setDefaults($defaults);
  }
  
  function formatPrefferedCollectionDay($collectionDay) {
    $ends = array('th','st','nd','rd','th','th','th','th','th','th');
    if (($collectionDay%100) >= 11 && ($collectionDay%100) <= 13)
      $abbreviation = $collectionDay. 'th';
    else
      $abbreviation = $collectionDay. $ends[$collectionDay % 10];
    
    return $abbreviation;
  }

  /*
   * Function will return the SUN number broken down into individual characters passed as an array
   */
  function getSUNParts() {

    $SUNArray = str_split(self::getSUN());

    return $SUNArray;
  }

  /*
   * Function will return the SUN number broken down into individual characters passed as an array
   */
  function getSUN() {

    $SUN = CRM_Core_BAO_Setting::getItem(self::SETTING_GROUP_UK_DD_NAME,'service_user_number');    

    return $SUN;
  }
  
  /*
   * Function will return the Payment instrument to be used by DD payment processor
   */
  function getDDPaymentInstrumentID() {

    return 6;
  }  

    /*
   * Function will return the possible array of collection days with formatted label
   */
  function getCollectionDaysOptions() {
    
    $collectionDays = CRM_Core_BAO_Setting::getItem(self::SETTING_GROUP_UK_DD_NAME,'collection_days');

    // Split the array
    $tempCollectionDaysArray = explode(',', $collectionDays);

    // Loop through and format each label
    foreach( $tempCollectionDaysArray as $key => $value){
      $collectionDaysArray[$value] = self::formatPrefferedCollectionDay($value);
    }

    return $collectionDaysArray;
  }
  
  /*
   * Called after contribution page has been completed
   * Main purpose is to tidy the contribution
   * And to setup the relevant Direct Debit Mandate Information
   */
  function completeDirectDebitSetup($response, &$params)  {
      
    require_once 'api/api.php';

    // Check if the contributionRecurID is set
    // If so then update the trxn id with the mandate number
    // Edit the start date to be the correct date
    if (!empty($params['contributionRecurID'])) {
      require_once 'CRM/Contribute/DAO/ContributionRecur.php';
      $recurDAO = new CRM_Contribute_DAO_ContributionRecur();
      $recurDAO->id = $params['contributionRecurID'];
      $recurDAO->find();
      $recurDAO->fetch();
      
      $transaction = new CRM_Core_Transaction();
      
      $recurDAO->start_date = CRM_Utils_Date::isoToMysql($response['start_date']);
      $recurDAO->create_date = CRM_Utils_Date::isoToMysql($recurDAO->create_date);
      $recurDAO->modified_date = CRM_Utils_Date::isoToMysql($recurDAO->modified_date);
      $recurDAO->payment_instrument_id = self::getDDPaymentInstrumentID();
            
      $recurDAO->trxn_id = CRM_Utils_Date::isoToMysql($response['trxn_id']);
      
      $recurDAO->save();

      if ($objects == CRM_Core_DAO::$_nullObject) {
        $transaction->commit();
      }
      else {
        require_once 'CRM/Core/Payment/BaseIPN.php';
        $baseIPN = new CRM_Core_Payment_BaseIPN();
        return $baseIPN->cancelled($objects, $transaction);
      }

    }
    
    // Check if the contributionID has been set
    // If so update it to be the same date as the start date
    if (!empty($params['contributionID'])) {
        
      //$contributionArray = civicrm_api('Contribution', 'Get', array('id' => $params['contributionID'], 'version' => 3));
      
      //$contribution = $contributionArray['values'][$contributionArray['id']];
      $contribution['id'] = $params['contributionID'];
      $contribution['contribution_id'] = $params['contributionID'];
      $contribution['receive_date'] = CRM_Utils_Date::isoToMysql($response['start_date']);
      $contribution['payment_instrument_id'] = self::getDDPaymentInstrumentID();
      $contribution['payment_instrument'] = 'Direct Debit';
      
      $contribution['version'] = 3;

      $updatedContribution = civicrm_api('Contribution', 'Update', $contribution);        
    }

    // TODO Create an activity to indicate Direct Debit Sign up? Attach Letter above
    $activityID = self::createDDSignUpActivity($response, $params);

    // TODO Create mail merged file with Direct Debit Mandate
    
    // Get the HTML template for DD confirmation
    $default_html = self::getDDConfirmationTemplate();
    
    // TODO Merge in the tokens to the document
    // Merge the document with the contact in question
    
    // Are we emailing this (depending on the communication preference chosen during sign up?)
    // if we are then also set the status of the activity to completed as there is no need to send out a paper form
    
    // Turn into a PDF and attach to activity
    require_once("CRM/Core/Config.php");
    $config =& CRM_Core_Config::singleton( );  
    $file_name = 'DDSignUp-Activity-'.$activityID.'.pdf';
    $csv_path = $config->customFileUploadDir;
    $filePathName   = "{$csv_path}{$file_name}";
                    
    $fileContent = self::html2pdf( $default_html , $file_name , "external");

    $handle = fopen($filePathName, 'w');
    file_put_contents($filePathName, $fileContent);
    fclose($handle);

    // We're not doing this as deleting the file removes the link and you can no longer open it    // S
    // self::insert_file_for_activity($file_name , $activityID);

    // Delete the physical file
 
    // TODO Finally put an entry into the civicrm_direct_debit_mandates table
    $entity_ref = array(
        'key'         => 'contribution',
        'recurring'   => 'contribution_recur',
        'log message' => isset($params['entity_type']) ? $params['entity_type'] : 'message'
    );

    CRM_Core_DAO::executeQuery("
        INSERT INTO civicrm_sagepay
        (created
        ,data_type
        ,entity_type
        ,entity_id
        ,sort_code
        ,account_number)
        VALUES
        (NOW()
        ,'recurring'
        ,'contribution_recur'
        , %1
        , %2)
        ", array(
        1 => array(isset($recurDAO->id) ? $recurDAO->id : 0, 'Integer'),
        2 => array(isset($entity_ref[$data_type]) ? $entity_ref[$data_type] : 'nothing', 'String'),
        3 => array(isset($params['entity_id']) ? $params['entity_id'] : 0, 'Integer'),
        4 => array(serialize($params['data']), 'String')
        )
    );
    
    
    
    // TODO Link back to the recurring ID
    
  }

  function createDDSignUpActivity($response, &$params) {
      
    $params = array(
                'source_contact_id' => $params['contactID'],
                'target_contact_id' => $params['contactID'],
                'activity_type_id'  => self::DD_SIGN_UP_ACITIVITY_TYPE_ID,
                'subject' => 'Direct Debit Sign Up, Mandate ID : '.$response['trxn_id'],
                'activity_date_time' => date('YmdHis'),
                //'details'=> $html,
                'status_id'=> 1,
                'version' => 3
                );

    require_once 'api/api.php';
    $result = civicrm_api( 'activity','create',$params );
    $activityID = $result['id'];

    return $activityID;
  }
  
  function firstCollectionDate($collectionDay, $startDate) {

    // Initialise date objects with today's date
    $today                   = new DateTime();
    $todayPlusDateInterval   = new DateTime();
    $collectionDateThisMonth = new DateTime();
    $collectionDateNextMonth = new DateTime();
    
    $interval = CRM_Core_BAO_Setting::getItem(self::SETTING_GROUP_UK_DD_NAME,'collection_interval');

    // If we are not starting from today, then reset today's date and interval date        
    if (!empty($startDate)) {
        $today = DateTime::createFromFormat('Y-m-d', $startDate);
        $todayPlusDateInterval = DateTime::createFromFormat('Y-m-d', $startDate);
    }
    
    $dateInterval = '+'.$interval.' day';
    $todayPlusDateInterval->modify($dateInterval);
    
    // Get the current year, month and next month to create the 2 potential collection dates
    $todaysMonth = $todayPlusDateInterval->format('m');
    $todaysYear  = $todayPlusDateInterval->format('Y');

    $collectionDateThisMonth->setDate($todaysYear, $todaysMonth, $collectionDay);
    
    $collectionDateNextMonth = $collectionDateThisMonth;
    $monthDateInterval = '+1 month';
    $collectionDateNextMonth->modify($monthDateInterval);
    
    // Determine which is the next collection date
    if ($todayPlusDateInterval > $collectionDateThisMonth) {
      $returnDate = $collectionDateNextMonth;
    } 
    else {
      $returnDate = $collectionDateThisMonth;
    }
    
    return $returnDate;
    
  }
  
  function directDebitSignUpNofify($type, $contactID, $pageID, $recur, $autoRenewMembership = FALSE) {
    $value = array();
    if ($pageID) {
      CRM_Core_DAO::commonRetrieveAll('CRM_Contribute_DAO_ContributionPage', 'id',
        $pageID, $value,
        array(
          'title', 'is_email_receipt', 'receipt_from_name',
          'receipt_from_email', 'cc_receipt', 'bcc_receipt',
        )
      );
    }

    $isEmailReceipt = CRM_Utils_Array::value('is_email_receipt', $value[$pageID]);
    $isOfflineRecur = FALSE;
    if (!$pageID && $recur->id) {
      $isOfflineRecur = TRUE;
    }
    if ($isEmailReceipt || $isOfflineRecur) {
      if ($pageID) {
        $receiptFrom = '"' . CRM_Utils_Array::value('receipt_from_name', $value[$pageID]) . '" <' . $value[$pageID]['receipt_from_email'] . '>';

        $receiptFromName = $value[$pageID]['receipt_from_name'];
        $receiptFromEmail = $value[$pageID]['receipt_from_email'];
      }
      else {
        require_once 'CRM/Core/BAO/Domain.php';
        $domainValues     = CRM_Core_BAO_Domain::getNameAndEmail();
        $receiptFrom      = "$domainValues[0] <$domainValues[1]>";
        $receiptFromName  = $domainValues[0];
        $receiptFromEmail = $domainValues[1];
      }

      require_once 'CRM/Contact/BAO/Contact/Location.php';
      list($displayName, $email) = CRM_Contact_BAO_Contact_Location::getEmailDetails($contactID, FALSE);
      $templatesParams = array(
        'groupName' => 'msg_tpl_workflow_contribution',
        'valueName' => 'contribution_recurring_notify',
        'contactId' => $contactID,
        'tplParams' => array(
          'recur_frequency_interval' => $recur->frequency_interval,
          'recur_frequency_unit' => $recur->frequency_unit,
          'recur_installments' => $recur->installments,
          'recur_start_date' => $recur->start_date,
          'recur_end_date' => $recur->end_date,
          'recur_amount' => $recur->amount,
          'recur_txnType' => $type,
          'displayName' => $displayName,
          'receipt_from_name' => $receiptFromName,
          'receipt_from_email' => $receiptFromEmail,
          'auto_renew_membership' => $autoRenewMembership,
        ),
        'from' => $receiptFrom,
        'toName' => $displayName,
        'toEmail' => $email,
      );

      require_once 'CRM/Core/BAO/MessageTemplates.php';
      list($sent, $subject, $message, $html) = CRM_Core_BAO_MessageTemplates::sendTemplate($templatesParams);

      if ($sent) {
        CRM_Core_Error::debug_log_message('Success: mail sent for recurring notification.');
      }
      else {
        CRM_Core_Error::debug_log_message('Failure: mail not sent for recurring notification.');
      }
    }
  }

  function insert_file_for_activity( $file_name , $activity_id ) {

        $upload_date = date('Y-m-d H:i:s');
        
        $file_sql = "INSERT INTO civicrm_file SET mime_type = %1 , uri = %2 , upload_date=%3";
        $file_params  = array( 
                              1 => array( "text/csv"   , 'String' ) ,
                              2 => array( $file_name   , 'String' ) ,
                              3 => array( $upload_date   , 'String' )  
                             );

        $file_dao = CRM_Core_DAO::executeQuery( $file_sql, $file_params );
        
        $select_sql = "SELECT id FROM civicrm_file WHERE mime_type = %1 AND uri = %2 AND upload_date = %3  ORDER BY id DESC";
        $select_dao = CRM_Core_DAO::executeQuery( $select_sql, $file_params );
        $select_dao->fetch();
        $file_id = $select_dao->id;
        
        $custom_sql = "INSERT INTO civicrm_entity_file SET entity_id = %1 , entity_table = %2 , file_id = %3";
        $custom_params  = array( 
                              1 => array( $activity_id   , 'Integer' ) ,
                              2 => array('civicrm_activity' , 'String') ,
                              3 => array( $file_id   , 'Integer' ) 
                             );
        
        $custom_dao = CRM_Core_DAO::executeQuery( $custom_sql, $custom_params );
  }    

  function getDDConfirmationTemplate() {
    $default_template_name = "direct_debit_confirmation";
    $default_template_sql = "SELECT * FROM civicrm_msg_template mt WHERE mt.msg_title = %1";
    $default_template_params  = array( 1 => array( $default_template_name , 'String' ));
    $default_template_dao = CRM_Core_DAO::executeQuery( $default_template_sql, $default_template_params );
    $default_template_dao->fetch();
    return $default_template_dao->msg_html;    
  }

  /*
   * Function to produce PDF
   * Author : rajesh@millertech.co.uk
   */
  static function html2pdf( $text , $fileName = 'FiscalReceipts.pdf' , $calling = "internal" ) {

      require_once 'packages/dompdf/dompdf_config.inc.php';
      spl_autoload_register('DOMPDF_autoload');
      $dompdf = new DOMPDF( );

      $values = array( );
      if ( ! is_array( $text ) ) {
          $values =  array( $text );
      } else {
          $values =& $text;
      }

      foreach ( $values as $value ) {
          $html .= "{$value}\n";
      }

      //echo $html;exit;

      $html = mb_convert_encoding($html, 'HTML-ENTITIES', 'UTF-8');

      $dompdf->load_html( $html );
      $dompdf->set_paper ('a4', 'portrait');
      $dompdf->render( );

  		if($calling == "external"){ // like calling from cron job
  			$fileContent = $dompdf->output();
  			return $fileContent;
  		}
  		else{
  			$dompdf->stream( $fileName );
  		}
  		exit;
  }
  


  function record_response($direct_debit_response) {

    CRM_Core_DAO::executeQuery("
        INSERT INTO civicrm_direct_debit
        (created
        ,data_type
        ,entity_type
        ,entity_id
        ,bank_name
        ,branch
        ,address1
        ,address2
        ,address3
        ,address4
        ,town
        ,county
        ,postcode
        ,first_collection_date
        ,preferred_collection_day
        ,confirmation_method
        ,ddi_reference
        ,response_status
        ,response_raw
        )
        VALUES
        ( NOW()
        , %1
        , %2
        , %3
        , %4
        , %5
        , %6
        , %7
        , %8
        , %9
        , %10
        , %11
        , %12
        , %13
        , %14
        , %15
        , %16
        , %17
        , %18
        )
        ", array(
        1  => array((string)$direct_debit_response['data_type']                 , 'String'),
        2  => array((string)$direct_debit_response['entity_type']               , 'String'),
        3  => array((integer)$direct_debit_response['entity_id']                , 'Integer'),
        4  => array((string)$direct_debit_response['bank_name']                 , 'String'),
        5  => array((string)$direct_debit_response['branch']                    , 'String'),
        6  => array((string)$direct_debit_response['address1']                  , 'String'),
        7  => array((string)$direct_debit_response['address2']                  , 'String'),
        8  => array((string)$direct_debit_response['address3']                  , 'String'),
        9  => array((string)$direct_debit_response['address4']                  , 'String'),
        10 => array((string)$direct_debit_response['town']                      , 'String'),
        11 => array((string)$direct_debit_response['county']                    , 'String'),
        12 => array((string)$direct_debit_response['postcode']                  , 'String'),
        13 => array((string)$direct_debit_response['first_collection_date']     , 'String'),
        14 => array((string)$direct_debit_response['preferred_collection_day']  , 'String'),
        15 => array((string)$direct_debit_response['confirmation_method']       , 'String'),
        16 => array((string)$direct_debit_response['ddi_reference']             , 'String'),
        17 => array((string)$direct_debit_response['response_status']           , 'String'),
        18 => array((string)$direct_debit_response['response_raw']              , 'String')
        )
    );            
  }

}