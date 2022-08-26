import React, {useEffect} from 'react'
import styles from "./newCss/Tests.module.css"
import {useNavigate} from "react-router-dom";
import {getIsReviewer} from "./Variables";

const PsyHome = () => {

    const navigate = useNavigate()

    //const [isReviewer, setIsReviewer] = useState(false)


    return (
        <div className={styles.testsBody}>
            <span className={styles.testName} onClick={() => navigate('/pending_test_results')}>Patient Scores And Responses</span>
            <hr className={styles.linePsy}></hr>
            <span className={styles.testName} onClick={() => navigate('/ptests')}>Update Questionnaire</span>
            <hr className={styles.linePsy}></hr>
            <span className={styles.testName} onClick={() => navigate('/create_file_request')}>Request File From Patients</span>
            <hr className={styles.linePsy}></hr>

            <span className={styles.testName} onClick={() => navigate('/')}>Pending Consultation Request</span>
            <hr className={styles.linePsy}></hr>

            {console.log(getIsReviewer())}
            {console.log(getIsReviewer() == true)}
            {getIsReviewer() === 'true' ? <>
            <span className={styles.testName} onClick={() => navigate('/')}>Review Psychiatrist Sign-up Requests</span>
            <hr className={styles.linePsy}></hr>
            <span className={styles.testName} onClick={() => navigate('/')}>Review Questionnaire Update Requests</span>
            <hr className={styles.linePsy}></hr>
            <span className={styles.testName} onClick={() => navigate('/')}>Review File Update Requests</span>
            <hr className={styles.linePsy}></hr> </> : <></> }
        </div>
    )
}

export default PsyHome