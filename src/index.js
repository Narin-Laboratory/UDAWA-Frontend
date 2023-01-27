// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getAuth, onAuthStateChanged } from 'firebase/auth';
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyCy4ElNv1XkANNNRwKH7hV85ZlnHok0gvE",
  authDomain: "udawa108.firebaseapp.com",
  projectId: "udawa108",
  storageBucket: "udawa108.appspot.com",
  messagingSenderId: "660795907920",
  appId: "1:660795907920:web:635299f4efb0652ab59655",
  measurementId: "G-KD0X452832"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const auth = getAuth(firebaseApp);

onAuthStateChanged(auth, user => {
    if(user != null){
        console.log('Logged in!');
    } else {
        console.log('No user!');
    }
});