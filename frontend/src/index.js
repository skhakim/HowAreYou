import React, {useEffect, useState} from 'react';
import ReactDOM from 'react-dom';
import {ListQuestionsOfATest} from "./components/test";

ReactDOM.render(
    <div>
        <ListQuestionsOfATest testId={2}/>
        <img src={"https:picsum.photos/500/300"} alt=""/></div>,
    document.querySelector('#root')
);
