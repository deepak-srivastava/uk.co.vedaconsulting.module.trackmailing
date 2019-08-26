<?php

class CRM_Trackmailing_Utils {
  function get_loggedIn_User() {
    $session    = &CRM_Core_Session::singleton( );
    $contactID  = $session->get('userID'        );
    return $contactID;
  }
  
   /**
    * Get the setting for a mailing or reminder.
    * @param int $reminderID
    * @param int $mailingID
    * @return array
    */
  public static function getSetting($reminderID, $mailingID) {
    $return = array();
    if ($reminderID || $mailingID) {
      $query = "SELECT id, schedule_reminder_id, mailing_id, is_respect_optout 
                    FROM civicrm_custom_track_mailing
      ";
      if ($reminderID) {
        $condition = "WHERE schedule_reminder_id = %1";
        $params[1] = [$reminderID, 'Integer'];
      }
      else {
        $condition =  "WHERE schedule_reminder_id = 0 AND mailing_id = %1";
        $params[1] = [$mailingID, 'Integer'];
      }
      $query .= $condition;
      $dao = CRM_Core_DAO::executeQuery($query, $params);
      // There should only be a single row (enforced at application level).
      if ($dao->fetch()) {
        $return = $dao->toArray(); 
      }
    }
    return $return;
  }
  
  /**
   * Save settings for mailing and/or schedule reminder.
   * @param array $params
   * @return boolean
   */
  public static function saveSetting($params) {
    $mailingID = CRM_Utils_Array::value('mailing_id', $params, 0);
    $reminderID = CRM_Utils_Array::value('schedule_reminder_id', $params, 0);
    // Default to respecting optout.
    $respectOptOut = CRM_Utils_Array::value('is_respect_optout', $params, 1);
    if (!$mailingID && !$reminderID) {
      CRM_Core_Error::debug_log_message(__CLASS__ . '::' . __FUNCTION__ .  ' : Warning schedule_reminder_id or mailing_id required.');
      return FALSE;
    }
    $existing = self::getSetting($reminderID, $mailingID);
    $queryParams = array(
        1 => [$reminderID, 'Integer'],
        2 => [$mailingID, 'Integer'],
        3 => [$respectOptOut, 'Integer'],
    );
    if (!empty($existing['id'])) {
      $query = "UPDATE civicrm_custom_track_mailing SET 
        schedule_reminder_id = %1,
        mailing_id = %2,
        is_respect_optout = %3
        WHERE id = %4
      ";
      $queryParams[4] = [$existing['id'], 'Integer'];
      CRM_Core_DAO::executeQuery($query,$queryParams);
    }
    else {
      $query = "INSERT INTO civicrm_custom_track_mailing
        (schedule_reminder_id, mailing_id, is_respect_optout)
        VALUES (%1, %2, %3) 
      ";
      CRM_Core_DAO::executeQuery($query,$queryParams);
    }
    return TRUE;
  }
}