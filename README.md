
Attach Scheduled Reminders to mass-mailings. 
By attaching scheduled reminder to mass-mailing, it gets the benefit of tracking, reminder scheduler, and even mailing composition (traditional or new mosaico).

**How it works:**
 - It creates a custom table where it links reminder (schedule_id) with mailing_id. And that's how it knows if a reminder is connected to a mailing. 
 - When reminder cron is run, hook_civicrm_alterMailParams() checks if the reminder is connected to mailing. 
 - For reminders connected to mailing, it aborts the reminder and adds the reminder-recipients to mailing, by queuing and re-opening the mailing.
 - Mailing cron (automatically) detects and sends mailing to the new recipients in the queue.

**UI Changes:**
Reminder screen shows a new option "Track Mailing", if checked shows a new dropdown where user can specify the mailing. The regular send-email options gets hidden in this case. See screenshot below.
There are no other changes visible in the UI.

![enter image description here](https://chat.civicrm.org/files/neh9fg9rr3n43mkktcmyz516zw/public?h=BXG1T-2iO6eVEFvigJOkX-Px-NVPiomY8GErA8UgdsM)

A change required in core CRM/Core/BAO/ActionSchedule.php for extension to work:

    diff --git a/CRM/Core/BAO/ActionSchedule.php b/CRM/Core/BAO/ActionSchedule.php
    index 1d23622..c5be683 100755
    --- a/CRM/Core/BAO/ActionSchedule.php
    +++ b/CRM/Core/BAO/ActionSchedule.php
    @@ -461,6 +461,8 @@ WHERE   cas.entity_value = $id AND
             'toName' => $contact['display_name'],
             'toEmail' => $email,
             'subject' => $messageSubject,
    +        'contact_id'  => $contactId, 
    +        'schedule_id' => $scheduleID 
           );
