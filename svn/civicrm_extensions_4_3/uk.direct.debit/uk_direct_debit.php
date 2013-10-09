<?php

function uk_direct_debit_civicrm_install( ) {
  
  require_once 'CRM/Core/BAO/Setting.php';
  CRM_Core_BAO_Setting::setItem('Veda Test Company',
          'UK Direct Debit',
          'company_name'
        );

  CRM_Core_BAO_Setting::setItem('15',
          'UK Direct Debit',
          'collection_interval'
        );

  CRM_Core_BAO_Setting::setItem('1,8,22',
          'UK Direct Debit',
          'collection_days'
        );
  
  CRM_Core_BAO_Setting::setItem('123456',
          'UK Direct Debit',
          'service_user_number'
        );

    // On install, create a table for keeping track of online direct debits
    require_once "CRM/Core/DAO.php";
    CRM_Core_DAO::executeQuery("
         CREATE TABLE IF NOT EXISTS `civicrm_direct_debit` (
        `id`                        int(10) unsigned NOT NULL auto_increment,
        `created`                   datetime NOT NULL,
        `data_type`                 varchar(16) NOT NULL,
        `entity_type`               varchar(32) NOT NULL,
        `entity_id`                 int(10) unsigned NOT NULL,
        `bank_name`                 varchar(100) ,
        `branch`                    varchar(100) ,
        `address1`                  varchar(100) ,
        `address2`                  varchar(100) ,
        `address3`                  varchar(100) ,
        `address4`                  varchar(100) ,
        `town`                      varchar(100) ,
        `county`                    varchar(100) ,
        `postcode`                  varchar(20)  ,
        `first_collection_date`     varchar(100) NOT NULL,
        `preferred_collection_day`  varchar(100) NOT NULL,   
        `confirmation_method`       varchar(100) NOT NULL,
        `ddi_reference`             varchar(100) NOT NULL,
        `response_status`           varchar(100) NOT NULL,
        `response_raw`              longtext     NOT NULL,
        PRIMARY KEY  (`id`),
        KEY `entity_id` (`entity_id`),
        KEY `data_type` (`data_type`)
        ) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
    ");
  
  /**
   * TODO Create contribution type Direct Debit
   * TODO New Activity Type Direct Debit Sign Up
   * TODO New Activity Type Direct Debit Mandate Sent
   */
  
  //$import->run($xml_file);
  //require_once('CRM_Core_Invoke');
  //CRM_Core_Invoke::rebuildMenuAndCaches( );
}

function uk_direct_debit_civicrm_enable() {  
/**    
  $dirRoot =dirname( __FILE__ ) . DIRECTORY_SEPARATOR;
  $xml_file = $dirRoot . 'sql' . DIRECTORY_SEPARATOR . 'xml' . DIRECTORY_SEPARATOR . 'vehicle.xml';
  require_once 'CRM/Utils/Migrate/Import.php';
  $import = new CRM_Utils_Migrate_Import();
  $import->run($xml_file);
 * 
 */
        
  CRM_Core_Invoke::rebuildMenuAndCaches( );
}

function uk_direct_debit_civicrm_config( &$config ) {
    
    $template =& CRM_Core_Smarty::singleton( );
    
    $schoolRoot = 
        dirname( __FILE__ ) . DIRECTORY_SEPARATOR ;

    $schoolDir = $schoolRoot . 'templates';

    if ( is_array( $template->template_dir ) ) {
        array_unshift( $template->template_dir, $schoolDir );
    } else {
        $template->template_dir = array( $schoolDir, $template->template_dir );
    }

    // also fix php include path
    $include_path = $schoolRoot . PATH_SEPARATOR . get_include_path( );

    set_include_path( $include_path );
    /**
    // assign the profile ids
    $gidStudent = CRM_Core_DAO::getFieldValue( 'CRM_Core_DAO_UFGroup', 'Student_Information', 'id', 'name' );
    $gidParent = CRM_Core_DAO::getFieldValue( 'CRM_Core_DAO_UFGroup', 'Parent_Information', 'id', 'name' );
    $template->assign( 'parentProfileID' , $gidParent  );
    $template->assign( 'studentProfileID', $gidStudent );
     *
     * @param type $page
     * @return type 
     */
    
}

function uk_direct_debit_civicrm_xmlMenu( &$files ) {
  $files[] = dirname(__FILE__)."/xml/Menu/DirectDebit.xml";
}


function _uk_direct_debit_civicrm_pageRun( &$page ) {
    $name = $page->getVar( '_name' );
    $gid = null;
    if ( $name == 'CRM_Profile_Page_Dynamic' ) {
        $gid = $page->getVar( '_gid' );
        $gname = CRM_Core_DAO::getFieldValue( 'CRM_Core_DAO_UFGroup', $gid, 'name', 'id' );
        switch ( $gname ) {
        case "Parent_Information":
            return _school_civicrm_pageRun_Profile_Page_Dynamic_Parent_Information( $page, $gid );
        case "Student_Information":
            return _school_civicrm_pageRun_Profile_Page_Dynamic_Student_Information( $page, $gid );
          case "Participant_Status":
            return _school_civicrm_pageRun_Profile_Page_Dynamic_Participant_Status( $page, $gid );  
        }
    } else if ( $name == 'CRM_Contact_Page_View_CustomData' ) {
        if ( $page->getVar( '_groupId' ) != $gid ) {
            return;
        }

        // get the details from smarty
        $smarty  =& CRM_Core_Smarty::singleton( );
        $details =& $smarty->get_template_vars( 'viewCustomData' );
        
        require_once 'School/Utils/ExtendedCare.php';
         School_Utils_ExtendedCare::sortDetails( $details );

         // CRM_Core_Error::debug( 'POST', $details );
        $smarty->assign_by_ref( 'viewCustomData', $details );
    }
}

function uk_direct_debit_civicrm_buildForm( $formName, &$form ) {
    require_once 'CRM/Core/Payment.php';
    require_once 'uk_direct_debit/Form/Main.php';
    if ( ($form->_paymentProcessor['payment_type'] & CRM_Core_Payment::PAYMENT_TYPE_DIRECT_DEBIT) && !empty($form->_submitValues['ddi_reference']) ){
        /*** select dwtails for ddi
         * then setup local array with all details
         * then smarty assign the array
         */
        $query  = " SELECT * ";
        $query .= " FROM civicrm_direct_debit ";
        $query .= " WHERE ddi_reference = %1 ";

        $params = array( 1 => array( (string)$form->_submitValues['ddi_reference'], 'String' ) );
        $dao = CRM_Core_DAO::executeQuery( $query, $params );

        if ($dao->fetch()) {          
            $uk_direct_debit['formatted_preferred_collection_day'] = UK_Direct_Debit_Form_Main::formatPrefferedCollectionDay($dao->preferred_collection_day);
            $uk_direct_debit['company_name']             = UK_Direct_Debit_Form_Main::getCompanyName();
            $uk_direct_debit['bank_name']                = $dao->bank_name; 
            $uk_direct_debit['branch']                   = $dao->branch; 
            $uk_direct_debit['address1']                 = $dao->address1; 
            $uk_direct_debit['address2']                 = $dao->address2; 
            $uk_direct_debit['address3']                 = $dao->address3; 
            $uk_direct_debit['address4']                 = $dao->address4; 
            $uk_direct_debit['town']                     = $dao->town; 
            $uk_direct_debit['county']                   = $dao->county; 
            $uk_direct_debit['postcode']                 = $dao->postcode; 
            $uk_direct_debit['first_collection_date']    = $dao->first_collection_date;  
            $uk_direct_debit['preferred_collection_day'] = $dao->preferred_collection_day; 
            $uk_direct_debit['confirmation_method']      = $dao->confirmation_method; 
        
            $form->assign( 'direct_debit_details', $uk_direct_debit );
            /** TO DO Unset the unused fields **/
        }
    } 

    if ($formName == 'CRM_DirectDebit_Form_DirectDebit') {
        if ($form->_eventId == EVENT_ID) {
          $form->addRule('price_3', ts('This field is required.'), 'required');
        }
    }
          
//    // get the details from smarty
//    $smarty  =& CRM_Core_Smarty::singleton( );
//    $details =& $smarty->get_template_vars( 'viewCustomData' );
//
//    require_once 'School/Utils/ExtendedCare.php';
//    School_Utils_ExtendedCare::sortDetails( $details );
//
//    // CRM_Core_Error::debug( 'POST', $details );
//    $smarty->assign_by_ref( 'viewCustomData', $details );
}

