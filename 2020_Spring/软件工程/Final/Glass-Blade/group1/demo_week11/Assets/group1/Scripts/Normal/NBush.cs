//Author: wmj


using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

namespace Com.Glassblade.Group1
{
    public class NBush : MonoBehaviour
    {
        NCameraFollow cam;       //相机跟随组件
        List<NCharacterBehavior> players;      //角色列表
        int allies_cnt;         //队友数量
                                //玩家在草丛里死亡的行为
        private UnityAction<NCharacterBehavior> playerDeadAction;
        void Start()
        {
            cam = GameObject.FindGameObjectWithTag("MainCamera").GetComponent<NCameraFollow>();       //获取相机跟随组价
            players = new List<NCharacterBehavior>();          //实例化角色列表
            allies_cnt = 0;                     //队友数量清零
                                                //初始化
            playerDeadAction = new UnityAction<NCharacterBehavior>(PlayerDead);
        }

        public void PlayerDead(NCharacterBehavior player)
        {
            OnTriggerExit(player.GetComponent<Collider>());
        }

        private void OnTriggerEnter(Collider other)
        {
            NCharacterBehavior player = other.GetComponent<NCharacterBehavior>();
            if (player && !players.Contains(player))
            {
                if (player.team == cam.team)           //如果是友军
                {
                    if (allies_cnt == 0)               //友军数量为0
                    {
                        foreach (NCharacterBehavior p in players)       //对角色列表中每个人
                        {
                            p.NBush = 1;         //设置为半透明
                        }
                    }
                    allies_cnt++;       //友军数量+1
                }
                player.NBush = allies_cnt == 0 ? 2 : 1;      //新来的是否可见
                players.Add(player);        //加入角色列表
            }
        }
        //大致同上
        private void OnTriggerExit(Collider other)
        {
            NCharacterBehavior player = other.GetComponent<NCharacterBehavior>();
            if (player && players.Contains(player))
            {
                players.Remove(player);
                player.NBush = 0;
                if (player.team == cam.team)
                {
                    allies_cnt--;
                    if (allies_cnt == 0)
                    {
                        foreach (NCharacterBehavior p in players)
                        {
                            p.NBush = 0;
                        }
                    }
                }
            }
        }
    }
}