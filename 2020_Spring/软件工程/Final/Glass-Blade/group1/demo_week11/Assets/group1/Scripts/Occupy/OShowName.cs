//Author: David Wang


using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Com.Glassblade.Group1
{
    public class OShowName : MonoBehaviour
    {
        //玩家名字组件
        private TextMesh playerName;

        /// <summary>
        /// 获取组件
        /// </summary>
        void Start()
        {
            //获取组件
            this.playerName = this.GetComponentInParent<TextMesh>();
        }

        /// <summary>
        /// 显示名字
        /// </summary>
        void Update()
        {
            //获取相机位置向量
            Vector3 cameraDirection = Camera.main.transform.forward;
            //清零y轴
            cameraDirection.y = 0f;
            //设置名字朝向
            this.playerName.transform.rotation = Quaternion.LookRotation(cameraDirection);
        }
    }
}
