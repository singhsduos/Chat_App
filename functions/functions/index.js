const functions = require('firebase-functions');

const admin = require('firebase-admin')
admin.initializeApp()

exports.sendNotification = functions.firestore
    .document("messages/senderId/receiverId/{receiverId}")
    .onCreate(async (snapshot, context) => {

        try {
            const notificationDocument = snapshot.data()
            const uid = context.params.user;
            const notificationMessage = notificationDocument.message;
           

            const userDoc = await admin.firestore().collection('users').doc(uid).get();
            // const notificationTitle = await admin.firestore().collection('users').doc(notificationDocument.recevierId).username.get();
            const token = userDoc.data().token
               
              

            const message = {
                'notification': {
                    title: notificationTitle,
                    // body: notificationMessage
                },
                to: token
            }

            //send notification

           return admin.messaging().send(message)

        } catch (error) {
            console.log(error)
        }
    })