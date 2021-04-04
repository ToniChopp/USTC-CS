var hourInput = document.getElementById("hour");
var minuteInput = document.getElementById("minute");
var secondInput = document.getElementById("second");
var hour;
var minute;
var second;

function HandleInput(){         //处理输入
    hour = hourInput.value;
    minute = minuteInput.value;
    second = secondInput.value;
    if(hour == null){
        hour = 0;
    }
    if(minute == null){
        minute = 0;
    }
    if(second == null){
        second = 0;
    }
    if(second > 59){
        second = 59;
    }
    if(minute > 59){
        minute = 59;
    }
    if(hour > 99){
        hour = 99;
    }
    if(second < 0){
        second = 0;
    }
    if(minute < 0){
        minute = 0;
    }
    if(hour < 0){
        minute = 0;
    }
}

var countHour = 0;
var countMinute = 0;
var countSecond = 0;

var num = document.getElementById("time");
function DisplayNumber(displayHour, displayMinute, displaySecond){            //数字显示函数
    displayHour = displayHour < 10 ? ('0' + displayHour) : displayHour;
    var displayMinute = displayMinute < 10 ? ('0' + displayMinute) : displayMinute;
    var displaySecond = displaySecond < 10 ? ('0' + displaySecond) : displaySecond;
    if(displayHour == 0){
        displayHour = '00';
    }
    if(displayMinute == 0){
        displayMinute = '00';
    }
    if(displaySecond == 0){
        displaySecond = '00';
    }
    num.innerHTML = displayHour + ':' + displayMinute + ':' + displaySecond;
}

var timer = null;
var count;
var startTime;
var normalElapse = 1000;
var nextElapse = normalElapse;
var up = 0;
var down = 0;

function CountingEnd(){                   //计时结束
    if((up == 2) || (down == 2)){
        countup.style.display = "none";
        countdown.style.display = "none";
        hourInputDisplay.style.display = "none";
        minuteInputDisplay.style.display = "none";
        secondInputDisplay.style.display = "none";
        pause.style.display = "none";
        restart.style.display = "inline-block";
        clear.style.display = "inline-block"
        resume.style.display = "none";
        var hintHour = hour < 10 ? ('0' + hour) : hour;
        var hintMinute = minute < 10 ? ('0' + minute) : minute;
        var hintSecond = second < 10 ? ('0' + second) : second;
        if(hintHour == 0){
            hintHour = '00';
        }
        if(hintMinute == 0){
            hintMinute = '00';
        }
        if(hintSecond == 0){
            hintSecond = '00';
        }
        if(down == 0){
            hint.innerHTML = '正计时 ' + hintHour + ':' + hintMinute + ':' + hintSecond + ' 已结束';    
        }
        else if(up == 0){
            hint.innerHTML = '倒计时 ' + hintHour + ':' + hintMinute + ':' + hintSecond + ' 已结束';
        }
        hint.style.width = "192px";
        hint.style.display = "inline-block";
    }
}

function CountUp(){                    //正计时函数
    count = 0;
    HandleInput();
    startTime = new Date().valueOf();
    timer = window.setInterval("CountUpCall()", nextElapse);
}
function CountUpCall(){
        if(countHour == hour){
            if(countMinute == minute){
                if(countSecond == second){
                    clearInterval(timer);
                    up = 2;           //表征正计时结束
                    CountingEnd();
                    return null;
                }
            }
        }

        countSecond += 1;
        if(countSecond > 59){
            countSecond = 0;
            countMinute ++;
        }
        if(countMinute > 59){
            countMinute = 0;
            countHour ++;
        }
        if(countHour > 99){
            countSecond = 0;
            countMinute = 0;
            countHour = 0;
        }

        DisplayNumber(countHour, countMinute, countSecond);
        // 清除上一次的定时器  
        window.clearInterval(timer);  
        // 自校验系统时间得到时间差, 并由此得到下次所启动的新定时器的时间nextelapse  
        count ++;   
        var counterSecs = count * 1000;  
        var elapseSecs = new Date().valueOf() - startTime;  
        var diffSecs = counterSecs - elapseSecs;  
        nextElapse = normalElapse + diffSecs;  
        if (nextElapse < 0){
            nextElapse = 0; 
        } 
        // 启动新的定时器  
        timer = window.setInterval("CountUpCall()", nextElapse);  
}

var downHour;
var downMinute;
var downSecond;
function CountDown(){                //倒计时函数
    count = 0;    
    startTime = new Date().valueOf();
    timer = window.setInterval("CountDownCall()",nextElapse);
}
function CountDownCall(){
    if(downHour == 0){
        if(downMinute == 0){
            if(downSecond == 0){
                clearInterval(timer);
                down = 2;           //表征倒计时结束
                CountingEnd();
                return null;
            }
        }
    }

    downSecond -= 1;
    if(downSecond < 0){
        downSecond = 59;
        downMinute --;
    }
    if(downMinute < 0){
        downMinute = 59;
        downHour --;
    }
    if(downHour < 0){
        clearInterval(timer);
        return;
    }
    DisplayNumber(downHour, downMinute, downSecond);
    // 清除上一次的定时器  
    window.clearInterval(timer);  
    // 自校验系统时间得到时间差, 并由此得到下次所启动的新定时器的时间nextelapse  
    count ++;   
    var counterSecs = count * 1000;  
    var elapseSecs = new Date().valueOf() - startTime;  
    var diffSecs = counterSecs - elapseSecs;  
    nextElapse = normalElapse + diffSecs;  
    if (nextElapse < 0){
        nextElapse = 0; 
    } 
    // 启动新的定时器  
    timer = window.setInterval("CountDownCall()", nextElapse);  
}

function clearCounter(){
    clearInterval(timer);
    if(down == 0){
        up = 0;
        countHour = 0;
        countMinute = 0;
        countSecond = 0;
        nextElapse = 1000;
    }
    if(up == 0){
        down = 0;
        nextElapse = 1000;
    }
    num.innerHTML = '00:00:00';
}

var alignElapse;
var alignNextElapse;
var alignCount;
var alignTimer;
function TimeAlign(){             //暂停校准函数
    alignCount = 0;
    alignTimer = window.setInterval("TimeAlignCall()", 10);
}
function TimeAlignCall(){
    alignElapse += 10;
    if(alignElapse == 1000){
        alignElapse = 0;
    }
    window.clearInterval(alignTimer);  
    // 自校验系统时间得到时间差, 并由此得到下次所启动的新定时器的时间nextelapse  
    alignCount ++;   
    var counterSecs = alignCount * 10;  
    var elapseSecs = new Date().valueOf() - startTime;  
    var diffSecs = counterSecs - elapseSecs;  
    alignNextElapse = 10 + diffSecs;  
    if (alignNextElapse < 0){
        alignNextElapse = 0; 
    } 
    // 启动新的定时器  
    alignTimer = window.setInterval("TimeAlignCall()", alignNextElapse);
}

var hint = document.getElementById("hint");
var pause = document.getElementById("pause");
var pauseState = 0;          //表征暂停状态，1=暂停
function Pause() {                          //暂停计时函数
    window.clearTimeout(timer);  
    window.clearTimeout(alignTimer);
}  
pause.onclick = function PauseCounter(){
    countup.style.display = "none";
    countdown.style.display = "none";
    hourInputDisplay.style.display = "none";
    minuteInputDisplay.style.display = "none";
    secondInputDisplay.style.display = "none";
    pause.style.display = "none";
    restart.style.display = "inline-block";
    clear.style.display = "inline-block"
    resume.style.display = "inline-block";
    pauseState = 1;
    Pause();
    var hintHour = hour < 10 ? ('0' + hour) : hour;
    var hintMinute = minute < 10 ? ('0' + minute) : minute;
    var hintSecond = second < 10 ? ('0' + second) : second;
    if(hintHour == 0){
        hintHour = '00';
    }
    if(hintMinute == 0){
        hintMinute = '00';
    }
    if(hintSecond == 0){
        hintSecond = '00';
    }
    if(down == 0){
        hint.innerHTML = '暂停正计时' + ' ' + hintHour + ':' + hintMinute + ':' + hintSecond;    
    }
    else if(up == 0){
        hint.innerHTML = '暂停倒计时' + ' ' + hintHour + ':' + hintMinute + ':' + hintSecond;
    }
    hint.style.display = "inline-block";
}

var restart = document.getElementById("restart");
var clear = document.getElementById("clear");

var countup = document.getElementById("countup");
var hourInputDisplay = document.getElementById("hourInput");
var minuteInputDisplay = document.getElementById("minuteInput");
var secondInputDisplay = document.getElementById("secondInput");
countup.onclick = function StartCountUp(){                 //开始正计时按钮
    countup.style.display = "none";
    countdown.style.display = "none";
    hourInputDisplay.style.display = "none";
    minuteInputDisplay.style.display = "none";
    secondInputDisplay.style.display = "none";
    resume.style.display = "none";
    pause.style.display = "inline-block";
    restart.style.display = "inline-block";
    clear.innerHTML = '清空正计时';
    clear.style.display = "inline-block";
    this.blur();
    up = 1;
    down = 0;     //正计时开始
    CountUp();
    TimeAlign();
    var hintHour = hour < 10 ? ('0' + hour) : hour;
    var hintMinute = minute < 10 ? ('0' + minute) : minute;
    var hintSecond = second < 10 ? ('0' + second) : second;
    if(hintHour == 0){
        hintHour = '00';
    }
    if(hintMinute == 0){
        hintMinute = '00';
    }
    if(hintSecond == 0){
        hintSecond = '00';
    }
    hint.innerHTML = '正在正计时' + ' ' + hintHour + ':' + hintMinute + ':' + hintSecond;
    hint.style.display = "inline-block";
}

var countdown = document.getElementById("countdown");
countdown.onclick = function StartCountDown(){               //开始倒计时按钮
    countup.style.display = "none";
    countdown.style.display = "none";
    hourInputDisplay.style.display = "none";
    minuteInputDisplay.style.display = "none";
    secondInputDisplay.style.display = "none";
    pause.style.display = "inline-block";
    restart.style.display = "inline-block";
    clear.innerHTML = '清空倒计时';
    clear.style.display = "inline-block";
    this.blur();
    up = 0;
    down = 1;              //倒计时开始
    HandleInput();
    downHour = hour;
    downMinute = minute;
    downSecond = second;
    CountDown();
    TimeAlign();
    var hintHour = hour < 10 ? ('0' + hour) : hour;
    var hintMinute = minute < 10 ? ('0' + minute) : minute;
    var hintSecond = second < 10 ? ('0' + second) : second;
    if(hintHour == 0){
        hintHour = '00';
    }
    if(hintMinute == 0){
        hintMinute = '00';
    }
    if(hintSecond == 0){
        hintSecond = '00';
    }
    hint.innerHTML = '正在倒计时' + ' ' + hintHour + ':' + hintMinute + ':' + hintSecond;
    hint.style.display = "inline-block";
}

var resume = document.getElementById("resume");
resume.onclick = function ResumeCounter(){            //从暂停恢复计时
    countup.style.display = "none";
    countdown.style.display = "none";
    hourInputDisplay.style.display = "none";
    minuteInputDisplay.style.display = "none";
    secondInputDisplay.style.display = "none";
    pause.style.display = "inline-block";
    restart.style.display = "inline-block";
    clear.style.display = "inline-block"
    resume.style.display = "none";
    pauseState = 0;
    if(up == 1){
        nextElapse = 1000 - alignElapse;
        CountUp();
        var hintHour = hour < 10 ? ('0' + hour) : hour;
        var hintMinute = minute < 10 ? ('0' + minute) : minute;
        var hintSecond = second < 10 ? ('0' + second) : second;
        if(hintHour == 0){
            hintHour = '00';
        }
        if(hintMinute == 0){
            hintMinute = '00';
        }
        if(hintSecond == 0){
            hintSecond = '00';
        }
        hint.innerHTML = '正在正计时' + ' ' + hintHour + ':' + hintMinute + ':' + hintSecond;
        hint.style.display = "inline-block";
    }
    if(down == 1){
        nextElapse = 1000 - alignElapse;
        CountDown();
        var hintHour = hour < 10 ? ('0' + hour) : hour;
        var hintMinute = minute < 10 ? ('0' + minute) : minute;
        var hintSecond = second < 10 ? ('0' + second) : second;
        if(hintHour == 0){
            hintHour = '00';
        }
        if(hintMinute == 0){
            hintMinute = '00';
        }
        if(hintSecond == 0){
            hintSecond = '00';
        }
        hint.innerHTML = '正在倒计时' + ' ' + hintHour + ':' + hintMinute + ':' + hintSecond;
        hint.style.display = "inline-block";
    }
    TimeAlign();
}

clear.onclick = function ClearCounter(){
    countup.style.display = "inline-block";
    countdown.style.display = "inline-block";
    hourInputDisplay.style.display = "inline-block";
    minuteInputDisplay.style.display = "inline-block";
    secondInputDisplay.style.display = "inline-block";
    pause.style.display = "none";
    restart.style.display = "none";
    clear.style.display = "none"
    resume.style.display = "none";
    hint.style.display = "none";
    pauseState = 0;
    this.blur();
    clearCounter();
}

restart.onclick = function RestartCounter(){
    countup.style.display = "none";
    countdown.style.display = "none";
    hourInputDisplay.style.display = "none";
    minuteInputDisplay.style.display = "none";
    secondInputDisplay.style.display = "none";
    pause.style.display = "inline-block";
    restart.style.display = "inline-block";
    clear.style.display = "inline-block"
    resume.style.display = "none";
    pauseState = 0;
    this.blur();
    clearInterval(timer);
    if(down == 0){            //从正计时开始重新正计时
        up = 1;
        down = 0;
        countHour = 0;
        countMinute = 0;
        countSecond = 0;
        nextElapse = 1000;
        CountUp();
        var hintHour = hour < 10 ? ('0' + hour) : hour;
        var hintMinute = minute < 10 ? ('0' + minute) : minute;
        var hintSecond = second < 10 ? ('0' + second) : second;
        if(hintHour == 0){
            hintHour = '00';
        }
        if(hintMinute == 0){
            hintMinute = '00';
        }
        if(hintSecond == 0){
            hintSecond = '00';
        }
        hint.innerHTML = '正在正计时' + ' ' + hintHour + ':' + hintMinute + ':' + hintSecond;
        hint.style.display = "inline-block";
    }
    if(up == 0){            //从倒计时开始重新倒计时
        up = 0;
        down = 1;
        HandleInput();
        downHour = hour;
        downMinute = minute;
        downSecond = second;
        CountDown();
        var hintHour = hour < 10 ? ('0' + hour) : hour;
        var hintMinute = minute < 10 ? ('0' + minute) : minute;
        var hintSecond = second < 10 ? ('0' + second) : second;
        if(hintHour == 0){
            hintHour = '00';
        }
        if(hintMinute == 0){
            hintMinute = '00';
        }
        if(hintSecond == 0){
            hintSecond = '00';
        }
        hint.innerHTML = '正在倒计时' + ' ' + hintHour + ':' + hintMinute + ':' + hintSecond;
        hint.style.display = "inline-block";
    }
}

document.onkeydown = function (e){
    if((e.keyCode == 13) && (up == 0) && (down == 0)){
        countup.style.display = "none";
        countdown.style.display = "none";
        hourInputDisplay.style.display = "none";
        minuteInputDisplay.style.display = "none";
        secondInputDisplay.style.display = "none";
        resume.style.display = "none";
        pause.style.display = "inline-block";
        restart.style.display = "inline-block";
        clear.innerHTML = '清空正计时';
        clear.style.display = "inline-block";
        up = 1;
        down = 0;     //正计时开始
        CountUp();
        var hintHour = hour < 10 ? ('0' + hour) : hour;
        var hintMinute = minute < 10 ? ('0' + minute) : minute;
        var hintSecond = second < 10 ? ('0' + second) : second;
        if(hintHour == 0){
            hintHour = '00';
        }
        if(hintMinute == 0){
            hintMinute = '00';
        }
        if(hintSecond == 0){
            hintSecond = '00';
        }
        hint.innerHTML = '正在正计时' + ' ' + hintHour + ':' + hintMinute + ':' + hintSecond;
        hint.style.display = "inline-block";
    }
    if(e.keyCode == 32){
        if((pauseState == 0) && ((up == 1) || (down == 1))){   //从计时到暂停
            countup.style.display = "none";
            countdown.style.display = "none";
            hourInputDisplay.style.display = "none";
            minuteInputDisplay.style.display = "none";
            secondInputDisplay.style.display = "none";
            pause.style.display = "none";
            restart.style.display = "inline-block";
            clear.style.display = "inline-block"
            resume.style.display = "inline-block";
            pauseState = 1;
            Pause();
            var hintHour = hour < 10 ? ('0' + hour) : hour;
            var hintMinute = minute < 10 ? ('0' + minute) : minute;
            var hintSecond = second < 10 ? ('0' + second) : second;
            if(hintHour == 0){
                hintHour = '00';
            }
            if(hintMinute == 0){
                hintMinute = '00';
            }
            if(hintSecond == 0){
                hintSecond = '00';
            }
            if(down == 0){
                hint.innerHTML = '暂停正计时' + ' ' + hintHour + ':' + hintMinute + ':' + hintSecond;    
            }
            else if(up == 0){
                hint.innerHTML = '暂停倒计时' + ' ' + hintHour + ':' + hintMinute + ':' + hintSecond;
            }
            hint.style.display = "inline-block";
            return;
        }
        if(pauseState == 1){     //恢复计时器
            countup.style.display = "none";
            countdown.style.display = "none";
            hourInputDisplay.style.display = "none";
            minuteInputDisplay.style.display = "none";
            secondInputDisplay.style.display = "none";
            pause.style.display = "inline-block";
            restart.style.display = "inline-block";
            clear.style.display = "inline-block"
            resume.style.display = "none";
            pauseState = 0;
            if(up == 1){
                CountUp();
                var hintHour = hour < 10 ? ('0' + hour) : hour;
                var hintMinute = minute < 10 ? ('0' + minute) : minute;
                var hintSecond = second < 10 ? ('0' + second) : second;
                if(hintHour == 0){
                    hintHour = '00';
                }
                if(hintMinute == 0){
                    hintMinute = '00';
                }
                if(hintSecond == 0){
                    hintSecond = '00';
                }
                hint.innerHTML = '正在正计时' + ' ' + hintHour + ':' + hintMinute + ':' + hintSecond;
                hint.style.display = "inline-block";
            }
            if(down == 1){
                CountDown();
                var hintHour = hour < 10 ? ('0' + hour) : hour;
                var hintMinute = minute < 10 ? ('0' + minute) : minute;
                var hintSecond = second < 10 ? ('0' + second) : second;
                if(hintHour == 0){
                    hintHour = '00';
                }
                if(hintMinute == 0){
                    hintMinute = '00';
                }
                if(hintSecond == 0){
                    hintSecond = '00';
                }
                hint.innerHTML = '正在倒计时' + ' ' + hintHour + ':' + hintMinute + ':' + hintSecond;
                hint.style.display = "inline-block";
            }
            return;
        }
    }
}