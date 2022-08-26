import logo from './logo.svg';
import './App.css';
import {getPersonId, getIdType, getUsername, clearAll} from './components/Variables.js';
import Header from './components/Header';
import Talks from './components/Talks';
import Footer from './components/Footer';
import LoginModal from './components/LoginModal';
import {useState, useEffect} from "react";
import LogoutModal from './components/LogoutModal';
import Tests from './components/Tests';
import {useCookies, Cookies, withCookies} from "react-cookie";
import {BrowserRouter as Router, Route, Routes, Switch, useParams} from 'react-router-dom'
import PsyHome from './components/PsyHome';
import Questions from './components/Questions';
import {ListQuestionsOfATest} from "./components/Questionnaire";
import ShowResponse from "./components/ShowResponse";
import ScoreNDResponse from "./components/ScoreNDResponse";
import VerifiedReports from './components/VerifiedReport';
import {CreateFileRequest} from "./components/FileRequest";
import ApprovedFileRequests from "./components/ApprovedFileRequests";
import {ApproveFileRequest, ViewFileRequest} from "./components/ViewFileRequest";
import {Upload} from "./components/Upload";
import AddOrDeleteQues from "./components/AddOrDeleteQues";
import AddQuestion from "./components/AddQuestion";
import DetailedQuesRequest from "./components/DetailedQuesRequest";
import ListQuesUpdates from "./components/ListQuesUpdates";
import LoginModalNew from './components/LoginModalNew';



function App() {

    const userLoggedIn = false;
    const [showLoginModal, changeLoginModal] = useState(false);
    const [showLogoutModal, changeLogoutModal] = useState(false);
    const [signupModal, changeSignupModal] = useState(false);

    // const [cookies, setCookie, removeCookie] = useCookies(-['user']);

    function RenderTest() {
        return <ListQuestionsOfATest testId={useParams().testId}/>
    }

    function RenderTestResult() {
        return <ShowResponse testResultId={useParams().trId} />
    }

    function RenderFileRequest() {
        return <ViewFileRequest frID={useParams().frID} />
    }

    function RenderReviewFileRequest() {
        return <ApproveFileRequest frID={useParams().frID} />
    }

    function RenderAddOrDeleteQuestion() {
        return <AddOrDeleteQues testID={useParams().testID} />
    }

    function RenderAddQuestion () {
        return <AddQuestion testID={useParams().testID} />
    }

    function RenderDetailedQuesRequest() {
        return <DetailedQuesRequest testID={useParams().testID} quesID={useParams().quesID} mode={useParams().mode} />
    }



    return (

        <Router>
            <div style={{background: "#FFFFE0"}}>
                <Header changeLoginModalFn={() => changeLoginModal(true)} loggedIn={(getPersonId() !== '')}
                        cngLogoutModalFn={() => changeLogoutModal(true)}/>

                <div>
                <Routes>

                    <Route path="/login" element={<LoginModal changeLoginModalFn={() => changeLoginModal(false)}
                                                         cngSignupModalFn={() => changeSignupModal(true)}
                                                         closeSignupModalFn={() => changeSignupModal(false)}
                                                         isSignUp={signupModal}/>}/>
                    
                    <Route path="/login2" element={<LoginModalNew />} />

                    <Route path="/logout" element={<LogoutModal changeLogoutModalFn={() => changeLogoutModal(false)}/>}/>

                    <Route path="/tests" element={<Tests/>}/>
                    <Route path="/tests/:testId" element={<RenderTest/>} />
                    <Route path="/psyhome" element={<PsyHome/>}/>
                    <Route path="/questions" element={<Questions/>}/>
                    <Route path={"/"} element={<Talks changeModalFn={() => changeLoginModal(true)}/>} />
                    <Route path="/show_verified_reports" element={ <VerifiedReports />} />

                    <Route path="/pending_test_results" element={<ScoreNDResponse/>} />
                    <Route path="/test_result/:trId" element={<RenderTestResult />}/>

                    <Route path="/create_file_request" element={<CreateFileRequest />} />
                    <Route path="/approved_file_requests" element={<ApprovedFileRequests />} />
                    <Route path="/file_request/:frID" element={<RenderFileRequest />} />
                    <Route path="/review_file_request/:frID" element={<RenderReviewFileRequest />} />

                    {/*<Route path="/upl" element={<Upload/>} />*/}

                    <Route path="/ptests" element={<Tests id={"psychiatrist"} />} />
                    <Route path="/a_d_ques/:testID" element={<RenderAddOrDeleteQuestion />}/>
                    <Route path="/a_ques/:testID" element={<RenderAddQuestion />}/>
                    <Route path="/list_ques_upd" element={<ListQuesUpdates />} />

                    <Route path="/det/:testID/:quesID/:mode" element={<RenderDetailedQuesRequest />} />



                </Routes>

                    </div>
                <Footer/>
            </div>
        </Router>
    );
}

export default App;
