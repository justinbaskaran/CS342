using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WindowsFormsApp4
{
    public partial class Form1 : Form
    {
        public class aInfo { public string au_id;
                            public string auName;
                            public override string ToString() { return auName; }
                            }
        public Form1()
        {
            InitializeComponent();
            using (var context = new pubsEntities())
            {
                var query = from st in context.authors
                            orderby st.au_lname
                            select st;

                foreach (author pa in query)
                {
                    aInfo tempA = new aInfo() { au_id = pa.au_id, auName = pa.au_fname + ", " + pa.au_lname };
                    listBox1.Items.Add(tempA);
                }
            }

        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            aInfo tRec = (aInfo)listBox1.SelectedItem;
            textBox1.Text = tRec.au_id;
            using (var context = new pubsEntities())
            {
                var aRecord = context.authors.First(a => a.au_id == tRec.au_id);
                textBox1.Text =
                    "ID: " + aRecord.au_id + "\r\n" +
                    "Last: " + aRecord.au_lname + "\r\n" +
                    "First: " + aRecord.au_fname + "\r\n" +
                    "Address: " + aRecord.address + "\r\n" +
                    "City: " + aRecord.city + "\r\n" +
                    "State: " + aRecord.state + "\r\n" +
                    "Zip: " + aRecord.zip + "\r\n";
            }
        }
    }
}
