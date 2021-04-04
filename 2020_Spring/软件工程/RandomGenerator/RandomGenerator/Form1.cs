using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace RandomGenerator
{


    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void btn_Click(object sender, EventArgs e)
        {
            int max = Int32.Parse(MaxInput.Text.ToString());
            int min = Int32.Parse(MinInput.Text.ToString());
            int num;
            RandomGen RG = new RandomGen();
            num = RG.GetRandom(min, max);
            display.Text = num.ToString();
        }
    }
    class RandomGen
    {
        public int GetRandom(int minNum, int maxNum)
        {
            Random r = new Random();
            int result = r.Next(minNum, maxNum);
            return result;
        }
    }
}
