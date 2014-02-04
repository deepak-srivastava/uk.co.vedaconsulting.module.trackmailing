
Attach Scheduled Reminders to bulk & sms mailings. 

A change required in core for extension to work:

diff --git a/CRM/Core/BAO/ActionSchedule.php b/CRM/Core/BAO/ActionSchedule.php
index 1d23622..c5be683 100755
--- a/CRM/Core/BAO/ActionSchedule.php
+++ b/CRM/Core/BAO/ActionSchedule.php
@@ -461,6 +461,8 @@ WHERE   cas.entity_value = $id AND
         'toName' => $contact['display_name'],
         'toEmail' => $email,
         'subject' => $messageSubject,
+        'contact_id'  => $contactId,  // PS 11/09/2013
+        'schedule_id' => $scheduleID  // PS 11/09/2013
       );
 
