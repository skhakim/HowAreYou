import logo from './logo.svg';
import './App.css';
import Header from './components/Header';
import Talks from './components/Talks';
import Footer from './components/Footer';
import LoginModal from './components/LoginModal';
import {useState} from "react";
// import LogoutModal from './components/LogoutModal';
// import Tests from './components/Tests';
// import PsyHome from './components/PsyHome';

function App() {

  const userLoggedIn = false;
  const [showLoginModal, changeLoginModal] = useState(false);
  const [showLogoutModal, changeLogoutModal] = useState(false);

  const promptLogin = async (loginInfo) => {
    console.log("Trying login", JSON.stringify(loginInfo))

    const res = await fetch('http://localhost:8001/login', 
      {
        method: "POST", 
        headers: {'Content-type': 'application/json'}, 
        body: JSON.stringify(loginInfo)
      }
    )
    const data = await res.json()

  }


  const [specificTests, changeSpecificTests] = useState([
    {
      id : 1,
      testName : "OCD Test",
      description : "Suffering from obsessive thoughts of compulsive behavior? Take a tour to our OCD tests."
    },
    {
      id : 2,
      testName : "PTSD Test",
      description : "Any horrible course of events that are still terrifying you? Find out through our PTSD tests."
    }
  ])

  return (
    
    <div>
      <Header changeModalFn={() => changeLoginModal(true)} loggedIn={userLoggedIn} cngLogoutModalFn={() => changeLogoutModal(true)}  />
      
      {/* {userLoggedIn ? (<Tests tests={specificTests} />) : (<Talks changeModalFn={() => changeLoginModal(true)} />)} */}

      {showLoginModal && <LoginModal onLogin={promptLogin} changeModalFn={() => changeLoginModal(false)} />}

      {/* {showLogoutModal && <LogoutModal cngLogoutModalFn={() => changeLogoutModal(false)}/>} */}

      {/* <PsyHome /> */}
      
      <Footer />
    </div>
  );
}

export default App;