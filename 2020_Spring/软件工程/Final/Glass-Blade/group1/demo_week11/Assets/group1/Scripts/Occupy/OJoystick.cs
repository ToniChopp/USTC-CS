//Author: wmj


using UnityEngine;
using UnityEngine.EventSystems;

namespace Com.Glassblade.Group1
{
    public class OJoystick : MonoBehaviour, IPointerDownHandler, IDragHandler, IPointerUpHandler
    {
        //摇杆
        public Transform handle;
        //轮盘
        public RectTransform panel;
        //最大位移
        public int maxRadius = 80;
        //获取位移
        public Vector2 Movement { get => movement; }
        //位移
        private Vector2 movement;

        /// <summary>
        /// 实现虚拟摇杆
        /// </summary>
        /// <param name="eventData"></param>
        public void OnDrag(PointerEventData eventData)
        {
            //可能需要区分pointerID
            //获取按钮位置
            RectTransformUtility.ScreenPointToLocalPointInRectangle(panel, eventData.position, eventData.pressEventCamera, out Vector2 position);
            //限制位移大小
            position = position.normalized * (position.magnitude > maxRadius ? maxRadius : position.magnitude);
            //设成对于最大位移的比例
            movement = position / maxRadius;
            //设置轮盘相对位移
            handle.localPosition = position;
        }

        /// <summary>
        /// 处理按钮事件
        /// </summary>
        /// <param name="eventData"></param>
        public void OnPointerDown(PointerEventData eventData)
        {
            OnDrag(eventData);
        }

        /// <summary>
        /// 归零
        /// </summary>
        /// <param name="eventData"></param>
        public void OnPointerUp(PointerEventData eventData)
        {
            movement = handle.localPosition = Vector2.zero;
        }

        //Author: Via Cytus

        /// <summary>
        /// 使用WASD控制移动
        /// </summary>
        void Update()
        {
            Vector2 position = new Vector2(0, 0);

            if (Input.GetKey("w"))
            {
                position.y++;
            }
            if (Input.GetKey("w"))
            {
                movement = position.normalized;
                handle.localPosition = position;
            }
            if (Input.GetKeyUp("w"))
            {
                movement = handle.localPosition = Vector2.zero;
            }


            if (Input.GetKey("a"))
            {
                position.x--;
            }
            if (Input.GetKey("a"))
            {
                movement = position.normalized;
                handle.localPosition = position;
            }
            if (Input.GetKeyUp("a"))
            {
                movement = handle.localPosition = Vector2.zero;
            }


            if (Input.GetKey("s"))
            {
                position.y--;
            }
            if (Input.GetKey("s"))
            {
                movement = position.normalized;
                handle.localPosition = position;
            }
            if (Input.GetKeyUp("s"))
            {
                movement = handle.localPosition = Vector2.zero;
            }


            if (Input.GetKey("d"))
            {
                position.x++;
            }
            if (Input.GetKey("d"))
            {
                movement = position.normalized;
                handle.localPosition = position;
            }
            if (Input.GetKeyUp("d"))
            {
                movement = handle.localPosition = Vector2.zero;
            }
        }
    }
}
