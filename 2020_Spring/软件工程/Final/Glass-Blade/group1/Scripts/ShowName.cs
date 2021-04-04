//Author: David Wang


using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Com.Glassblade.Group1
{
    public class ShowName : MonoBehaviour
    {
        //玩家名字组件
        private TextMesh PlayerName;
    
        void Start()
        {
            //获取组件
            this.PlayerName = this.GetComponentInParent<TextMesh>();
        }

    
        void Update()
        {
            //获取相机位置向量
            Vector3 cameraDirection = Camera.main.transform.forward;
            //清零y轴
            cameraDirection.y = 0f;
            //设置名字朝向
            this.PlayerName.transform.rotation = Quaternion.LookRotation(cameraDirection);
        }
    }
}
