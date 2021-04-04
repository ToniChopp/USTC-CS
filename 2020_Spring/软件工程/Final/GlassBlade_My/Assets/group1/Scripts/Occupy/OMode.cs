// Author: David Wang
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

namespace Com.Glassblade.Group1
{
    public class OMode : MonoBehaviour
    {
        // 占据队伍结果 null, 0, 1
        public int? team;
        // 暂时占据该点的队伍
        public int? tempTeam;
        // 玩家列表
        ArrayList Players;
        // 计数玩家数量，先入为主
        private int hostPlayer;
        // 计数玩家数量，后入为客
        private int guidePlayer;
        // 圈内玩家总人数
        private int playerCnt;

        // 占领倒计时,留为可调时间
        public int occupyCountDown;
        // 是否因为敌方玩家进入而暂停倒计时
        private bool stoped;
        // 倒计时中间时间
        public float currentTime;
        //add by wmj
        //占领加分幅度
        public int scoreInc;
        private UnityAction<OCharacterBehavior> playerDeadAction;

        public void PlayerDead(OCharacterBehavior player)
        {
            OnTriggerExit(player.GetComponent<Collider>());
        }
        //wmj ends

        /// <summary>
        /// 给变量做初始化
        /// </summary>
        void Start ()
        {
            // 起初占领结果为空
            team = null;
            // 占领倾向为空
            tempTeam = null;
            // 初始化玩家列表
            Players = new ArrayList();
            // 初始化主玩家数量
            hostPlayer = 0;
            // 初始化客（敌对）玩家数量
            guidePlayer = 0;
            // 初始化圈内玩家总数
            playerCnt = 0;
            // 刚开始默认暂停
            stoped = true;
            // 倒计时时间等于设定好的占领倒计时
            currentTime = (float)occupyCountDown;
            //add by wmj
            //init dict
            playerDeadAction = new UnityAction<OCharacterBehavior>(PlayerDead);
            //wmj ends
        }

        /// <summary>
        /// Update作为占领倒计时，倒计时结束则成功占领该点
        /// </summary>
        void Update ()
        {
            playerCnt = hostPlayer + guidePlayer;
            if (!stoped)
            {
                if (currentTime > 0)
                {
                    currentTime -= Time.deltaTime;
                }
                else
                {
                    if(currentTime<0)
                    {
                        //add by wmj,modify by Via Cytus
                        //这时点里玩家应全加分
                        foreach (OCharacterBehavior p in Players)
                        {
                            p.score += scoreInc;
                        }
                        //wmj ends
                    }
                    currentTime = 0;
                    // 倒计时结束，占领
                    team = tempTeam;
                }
            }
        }

        /// <summary>
        /// 进入触发盒，表示有玩家进入该点区域，做相应判别：首先该点是否未被本方占领，
        /// 且没有其他玩家在该区域内，是则开始倒计时。若该区域内已经有其他玩家，
        /// 判断是本方人还是对方人，本方人没有任何影响，对方人则暂停倒计时。
        /// 如果进入该点时已经被本方占领，则无影响
        /// </summary>
        private void OnTriggerEnter (Collider other)
        {
            // 获取玩家
            OCharacterBehavior player = other.GetComponent<OCharacterBehavior>();
            OPlayerCharacter status = other.GetComponent<OPlayerCharacter>();
            // Capsule 范围内有玩家
            if (player)
            {
                // 玩家是活着的
                if (status.isAlive)
                {
                    //add by wmj
                    //注册action
                    player.deathevent.AddListener(playerDeadAction);
                    //wmj ends

                    // 玩家进入了未被占领或者被地方占领的点
                    if (team != player.team)
                    {
                        // 占领点内没有玩家
                        if (hostPlayer == 0 && guidePlayer == 0)
                        {
                            // 占领点内主玩家数++
                            hostPlayer ++;
                            // 占领点有被主队占领的倾向
                            tempTeam = player.team;
                            // 开始计时
                            stoped = false;
                        }
                        else
                        {
                            // 同队玩家进入无影响
                            if(tempTeam == player.team)
                            {
                                hostPlayer ++;
                            }
                            // 敌方玩家进入，倒计时暂停
                            else
                            {
                                guidePlayer ++;
                                stoped = true;
                            }
                        }
                    }
                    // 玩家进入了己方已经占领的点，无影响
                    else
                    {
                        // 玩家进入了自己方占领状态但敌方正在夺取的点
                        if((tempTeam != null) && (player.team != tempTeam))
                        {
                            // 此时对于该点来说算作敌方
                            guidePlayer ++;
                            stoped = true;
                        }
                        // 玩家进入了正常状态下己方占领的点
                        else
                        {
                            hostPlayer ++;
                            tempTeam = player.team;
                        }
                    }
                    // 加入玩家列表
                    Players.Add (player);
                }
            }
        }

        /// <summary>
        /// 玩家离开占点区域的触发器，离开的玩家是本方玩家，若本方玩家全部离开，
        /// 则判断是否有对方玩家，有则重新开始计时。没有则占领倾向为空。
        /// 如果对方玩家全部离开则恢复倒计时
        /// </summary>
        private void OnTriggerExit(Collider other)
        {
            OCharacterBehavior player = other.GetComponent<OCharacterBehavior>();
            OPlayerCharacter status = other.GetComponent<OPlayerCharacter>();
            if (player)
            {
                //remove by wmj
                //死人要通过这个函数移出点
                //if (status.isAlive)
                //wmj ends
                {
                    //add by wmj
                    //移除action
                    player.deathevent.RemoveListener(playerDeadAction);
                    //wmj ends
                    Players.Remove(player);
                    // 离开的是本方玩家
                    if (player.team == tempTeam)
                    {
                        hostPlayer --;
                        // 本方玩家全部走掉
                        if (hostPlayer == 0)
                        {
                            // 对方开始变为主
                            hostPlayer = guidePlayer;
                            currentTime = (float)occupyCountDown;
                            stoped = true;
                            // 对方玩家也全部走掉
                            if (guidePlayer == 0)
                            {
                                // 占领倾向为空
                                tempTeam = null;
                            }
                            // 对方玩家没走
                            else if (guidePlayer > 0)
                            {
                                // 对方表现占领倾向
                                if (player.team == 0)
                                {
                                    tempTeam = 1;
                                }
                                else
                                {
                                    tempTeam = 0;
                                }
                                // 开始倒计时占领
                                stoped = false;  
                            }
                            guidePlayer = 0;
                        }
                        // 本方玩家还有留在区域内的
                        else
                        {
                            tempTeam = player.team;
                        }
                    }
                    // 对方玩家离开
                    else
                    {
                        guidePlayer --;
                        // 对方玩家全部离开
                        if(guidePlayer == 0)
                        {
                            stoped = false;
                        }
                    }
                }
            }
        }
    }
}

