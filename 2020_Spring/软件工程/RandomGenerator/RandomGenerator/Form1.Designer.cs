namespace RandomGenerator
{
    partial class Form1
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要修改
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.Max_Label = new System.Windows.Forms.Label();
            this.display = new System.Windows.Forms.TextBox();
            this.btn = new System.Windows.Forms.Button();
            this.MinInput = new System.Windows.Forms.TextBox();
            this.MaxInput = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // Max_Label
            // 
            this.Max_Label.AutoSize = true;
            this.Max_Label.Font = new System.Drawing.Font("Segoe Print", 18F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Max_Label.Location = new System.Drawing.Point(110, 114);
            this.Max_Label.Name = "Max_Label";
            this.Max_Label.Size = new System.Drawing.Size(0, 42);
            this.Max_Label.TabIndex = 1;
            // 
            // display
            // 
            this.display.Location = new System.Drawing.Point(165, 150);
            this.display.Name = "display";
            this.display.Size = new System.Drawing.Size(100, 21);
            this.display.TabIndex = 2;
            // 
            // btn
            // 
            this.btn.Font = new System.Drawing.Font("PingFang SC Regular", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btn.Location = new System.Drawing.Point(165, 189);
            this.btn.Name = "btn";
            this.btn.Size = new System.Drawing.Size(100, 31);
            this.btn.TabIndex = 3;
            this.btn.Text = "生成";
            this.btn.UseVisualStyleBackColor = true;
            this.btn.Click += new System.EventHandler(this.btn_Click);
            // 
            // MinInput
            // 
            this.MinInput.Location = new System.Drawing.Point(89, 36);
            this.MinInput.Name = "MinInput";
            this.MinInput.Size = new System.Drawing.Size(100, 21);
            this.MinInput.TabIndex = 4;
            // 
            // MaxInput
            // 
            this.MaxInput.Location = new System.Drawing.Point(89, 90);
            this.MaxInput.Name = "MaxInput";
            this.MaxInput.Size = new System.Drawing.Size(100, 21);
            this.MaxInput.TabIndex = 5;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Segoe Print", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(27, 34);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(45, 21);
            this.label1.TabIndex = 6;
            this.label1.Text = "min：";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Segoe Print", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(27, 88);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(47, 21);
            this.label2.TabIndex = 7;
            this.label2.Text = "max：";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(411, 232);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.MaxInput);
            this.Controls.Add(this.MinInput);
            this.Controls.Add(this.btn);
            this.Controls.Add(this.display);
            this.Controls.Add(this.Max_Label);
            this.Name = "Form1";
            this.Text = "Form1";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label Max_Label;
        private System.Windows.Forms.TextBox display;
        private System.Windows.Forms.Button btn;
        private System.Windows.Forms.TextBox MinInput;
        private System.Windows.Forms.TextBox MaxInput;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
    }
}

