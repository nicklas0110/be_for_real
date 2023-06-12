const admin = require("firebase-admin");
const functions = require("firebase-functions");

admin.initializeApp();

/**
 * Sends the daily notification.
 * @return {Promise} A Promise that resolves when the notification is sent.
 */
function sendDailyNotification() {
  const message = {
    notification: {
      title: "Daily Reminder",
      body: "Time to be ForReal, post your daily picture!",
    },
    topic: "daily_notifications",
  };

  // Send the notification using Firebase Cloud Messaging
  return admin.messaging().send(message)
      .then(() => {
        console.log("Daily notification sent successfully!");
        return null;
      })
      .catch((error) => {
        console.error("Error sending daily notification:", error);
        return null;
      });
}

// Schedule the Cloud Function to run once a day at a random time
exports.sendDailyFlutterNotifications = functions.pubsub
    .schedule("every day")
    .onRun((context) => {
      const randomMinutes = Math.floor(Math.random() * 1440);
      const date = new Date();
      date.setMinutes(randomMinutes);

      console.log("Scheduling daily notification for:", date);

      // Schedule the notification
      return functions.pubsub.schedule(date).onRun((context) => {
        sendDailyNotification();
        return null;
      });
    });

