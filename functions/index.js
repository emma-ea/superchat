const functions = require("firebase-functions");

const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const {onCall} = require("firebase-functions/v1/https");

initializeApp();

const firestore = getFirestore();

// if window closed.. remove userId from users
exports.deleteUserRecord = onCall((request)=> {
  const uid = request.data.uid;
  const collection = request.data.collection;
  firestore.collection(collection).doc(uid).delete().then((ret) => {
    functions.logger.info(ret);
  });
});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
