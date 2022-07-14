// import logo from './logo.svg';
import './App.css';
import Header from './components/Header';
import Talks from './components/Talks';
import Footer from './components/Footer';
import LoginModal from './components/LoginModal';
import {useState} from "react";

function App() {

  const [showLoginModal, changeLoginModal] = useState(false);

  return (
    
    <div>
      <Header changeModalFn={() => changeLoginModal(true)} />
      <Talks changeModalFn={() => changeLoginModal(true)}  />
      {showLoginModal && <LoginModal changeModalFn={() => changeLoginModal(false)} />}
      
      <Footer />
    </div>
  );
}

export default App;
