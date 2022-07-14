import React from 'react'
import './Talks.css'

const Talks = ({changeModalFn}) => {
  return (
    <div className='talks-body'>
        Sometimes things happen to people that are unusually or especially frightening, horrible, or traumatic. For example:
        <ul>
            <li>a serious accident or fire</li>
            <li>a natural calamity</li>
            <li>a physical or sexual assault or abuse</li>
            <li>a war</li>
            <li>seeing someone be killed or seriously injured</li>
            <li>having a loved one die through homicide or suicide</li>
        </ul>
        Have you experienced this kind of events before?<br /><br />
        <b>If YES, <u><span className="take-a-tour" onClick={changeModalFn}>take a tour to our mental health tests.</span></u></b><br /><br />
        
        <hr className='line'></hr>
        Source:<br /><br />
        PC-PTSSD is in Public-Domain and is available at  <br />
        <a href="https://www.ptsd.va.gov/professional/assessment/screens/pc-ptsd.asp">https://www.ptsd.va.gov/professional/assessment/screens/pc-ptsd.asp</a> <br /><br />
        DSM-5 Manual by The American Psychiatrist Association is available at   <br />             
        <a href="https://www.psychiatry.org/psychiatrists/practice/dsm">https://www.psychiatry.org/psychiatrists/practice/dsm</a><br /><br />
    </div>
  )
}

export default Talks