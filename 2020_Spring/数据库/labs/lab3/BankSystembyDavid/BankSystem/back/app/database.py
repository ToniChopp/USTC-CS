from flask_sqlalchemy import SQLAlchemy
from .app import app

# database instance
app.config['SQLALCHEMY_DATABASE_URI'] = "mysql://david:1234@localhost/bank"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)


IDENTITY_CODE_LEN = 18
NAME_LEN = 10
PHONE_LEN = 11
ADDRESS_LEN = 50
EMAIL_LEN = 20
RELATIONSHIP_LEN = 10
CODE_LEN = 18
CITY_LEN = 20
TYPE_LEN = 20


class Customer(db.Model):
    # start attributes
    c_identity_code = db.Column(db.String(IDENTITY_CODE_LEN), primary_key=True)
    c_name = db.Column(db.String(NAME_LEN), nullable=False)
    c_phone = db.Column(db.String(PHONE_LEN), nullable=False)
    c_address = db.Column(db.String(ADDRESS_LEN), nullable=False)
    c_contact_name = db.Column(db.String(IDENTITY_CODE_LEN), nullable=False)
    c_contact_phone = db.Column(db.String(NAME_LEN), nullable=False)
    c_contact_email = db.Column(db.String(EMAIL_LEN), nullable=False)
    c_contact_relationship = db.Column(db.String(RELATIONSHIP_LEN), nullable=False)
    # end attributes

    # start foreign keys
    c_loan_staff_identity_code = db.Column(
        db.String(IDENTITY_CODE_LEN),
        db.ForeignKey('staff.s_identity_code'),
        nullable=True
    )
    c_account_staff_identity_code = db.Column(
        db.String(IDENTITY_CODE_LEN),
        db.ForeignKey('staff.s_identity_code'),
        nullable=True
    )
    # end foreign keys

    def __init__(
            self, c_identity_code, c_name, c_phone, c_address, c_contact_name,
            c_contact_email, c_contact_phone, c_contact_relationship,
            c_loan_staff_identity_code=None, c_account_staff_identity_code=None):
        self.c_identity_code = c_identity_code
        self.c_name = c_name
        self.c_phone = c_phone
        self.c_address = c_address
        self.c_contact_name = c_contact_name
        self.c_contact_email = c_contact_email
        self.c_contact_phone = c_contact_phone
        self.c_contact_relationship = c_contact_relationship
        if c_loan_staff_identity_code is not None:
            self.c_loan_staff_identity_code = c_loan_staff_identity_code
        if c_account_staff_identity_code is not None:
            self.c_account_staff_identity_code = c_account_staff_identity_code

    def to_json(self):
        return {
            'c_identity_code': self.c_identity_code,
            'c_name': self.c_name,
            'c_phone': self.c_phone,
            'c_address': self.c_address,
            'c_contact_name': self.c_contact_name,
            'c_contact_email': self.c_contact_email,
            'c_contact_phone': self.c_contact_phone,
            'c_contact_relationship': self.c_contact_relationship,
            'c_loan_staff_identity_code': self.c_loan_staff_identity_code,
            'c_account_staff_identity_code': self.c_account_staff_identity_code
        }

    pass


class Staff(db.Model):
    # start attributes
    s_identity_code = db.Column(db.String(IDENTITY_CODE_LEN), primary_key=True)
    s_name = db.Column(db.String(NAME_LEN), nullable=False)
    s_phone = db.Column(db.String(PHONE_LEN), nullable=False)
    s_address = db.Column(db.String(ADDRESS_LEN), nullable=False)
    s_start_work_date = db.Column(db.Date, nullable=False)
    # end attributes

    # start foreign keys
    s_d_code = db.Column(
        db.String(CODE_LEN),
        db.ForeignKey('department.d_code'),
        nullable=True
    )
    # end foreign keys

    def __init__(
            self, s_identity_code, s_name, s_phone, s_address,
            s_start_work_date, s_d_code=None):
        self.s_identity_code = s_identity_code
        self.s_name = s_name
        self.s_phone = s_phone
        self.s_address = s_address
        self.s_start_work_date = s_start_work_date
        if s_d_code is not None:
            self.s_d_code = s_d_code
    pass


class SubBank(db.Model):
    # start attributes
    sb_name = db.Column(db.String(NAME_LEN), primary_key=True)
    sb_city = db.Column(db.String(CITY_LEN), nullable=False)
    sb_assets = db.Column(db.Float, nullable=False)
    # end attributes

    # start foreign keys
    # no foreign key
    # end foreign keys

    def __init__(self, sb_name, sb_city, sb_assets):
        self.sb_name = sb_name
        self.sb_city = sb_city
        self.sb_assets = sb_assets

    pass


class Department(db.Model):
    # start attributes
    d_code = db.Column(db.String(CODE_LEN), primary_key=True)
    d_name = db.Column(db.String(NAME_LEN), nullable=False)
    d_type = db.Column(db.String(TYPE_LEN), nullable=False)
    # end attributes

    # start foreign keys
    d_m_identity_code = db.Column(
        db.String(IDENTITY_CODE_LEN),
        db.ForeignKey('manager.m_identity_code'),
        nullable=True
    )
    d_sb_name = db.Column(
        db.String(NAME_LEN),
        db.ForeignKey('sub_bank.sb_name'),
        nullable=True
    )
    # end foreign keys

    def __init__(self, d_code, d_name, d_type, d_m_identity_code=None, d_sb_name=None):
        self.d_code = d_code
        self.d_name = d_name
        self.d_type = d_type
        if d_m_identity_code is not None:
            self.d_m_identity_code = d_m_identity_code
        if d_sb_name is not None:
            self.d_sb_name = d_sb_name

    pass


class Manager(db.Model):
    # start attributes
    m_identity_code = db.Column(
        db.String(IDENTITY_CODE_LEN),
        db.ForeignKey('staff.s_identity_code'),
        primary_key=True)
    # end attributes

    # start foreign keys
    m_d_code = db.Column(
        db.String(CODE_LEN),
        db.ForeignKey('department.d_code'),
        nullable=True
    )
    # end foreign keys

    def __init__(self, m_identity_code, m_d_code=None):
        self.m_identity_code = m_identity_code
        if m_d_code is not None:
            self.m_d_code = m_d_code

    pass


class Account(db.Model):
    # start attributes
    a_code = db.Column(db.String(CODE_LEN), primary_key=True)
    a_balance = db.Column(db.Float, nullable=False)
    a_open_date = db.Column(db.Date, nullable=False)
    # end attributes

    # start foreign keys
    a_open_bank = db.Column(
        db.String(NAME_LEN),
        db.ForeignKey('sub_bank.sb_name'),
        nullable=False
    )
    # end foreign keys

    def __init__(self, a_code, a_balance, a_open_date, a_open_bank):
        self.a_code = a_code
        self.a_balance = float(a_balance)
        self.a_open_date = a_open_date
        self.a_open_bank = a_open_bank
    pass


class CheckingAccount(db.Model):
    # start attributes
    ca_credit = db.Column(db.Float, nullable=False)
    # end attributes

    # start foreign keys
    ca_a_code = db.Column(
        db.String(CODE_LEN),
        db.ForeignKey('account.a_code'),
        primary_key=True
    )
    # end foreign keys

    def __init__(self, ca_credit, ca_a_code):
        self.ca_credit = float(ca_credit)
        self.ca_a_code = ca_a_code

    pass


class SavingsAccount(db.Model):
    # start attributes
    sa_rate = db.Column(db.Float, nullable=False)
    sa_currency_type = db.Column(db.String(TYPE_LEN), nullable=False)
    # end attributes

    # start foreign keys
    sa_a_code = db.Column(
        db.String(CODE_LEN),
        db.ForeignKey('account.a_code'),
        primary_key=True
    )
    # end foreign keys

    def __init__(self, sa_rate, sa_currency_type, sa_a_code):
        self.sa_rate = float(sa_rate)
        self.sa_currency_type = sa_currency_type
        self.sa_a_code = sa_a_code

    pass


class Loan(db.Model):
    # start attributes
    l_code = db.Column(db.String(CODE_LEN), primary_key=True)
    l_money = db.Column(db.Float, nullable=False)
    # end attributes

    # start foreign keys
    l_sb_name = db.Column(
        db.String(NAME_LEN),
        db.ForeignKey('sub_bank.sb_name'),
        nullable=True
    )
    # end foreign keys

    def __init__(self, l_code, l_money, l_sb_name=None):
        self.l_code = l_code
        self.l_money = l_money
        if l_sb_name is not None:
            self.l_sb_name = l_sb_name

    pass


class LoanPayment(db.Model):
    # start attributes
    lp_code = db.Column(db.String(CODE_LEN), primary_key=True)
    lp_date = db.Column(db.Date, nullable=False)
    lp_money = db.Column(db.Float, nullable=False)
    # end attributes

    # start foreign keys
    lp_l_code = db.Column(
        db.String(CODE_LEN),
        db.ForeignKey('loan.l_code'),
        primary_key=True
    )
    # end foreign keys

    def __init__(self, lp_code, lp_date, lp_money, lp_l_code):
        self.lp_code = lp_code
        self.lp_date = lp_date
        self.lp_money = lp_money
        self.lp_l_code = lp_l_code

    pass


class CheckingAccountRecord(db.Model):
    # start attributes
    car_last_visit_time = db.Column(db.Date, nullable=True)
    # end attributes

    # start foreign keys
    car_c_identity_code = db.Column(
        db.String(IDENTITY_CODE_LEN),
        db.ForeignKey('customer.c_identity_code'),
        primary_key=True
    )
    car_sb_name = db.Column(
        db.String(NAME_LEN),
        db.ForeignKey('sub_bank.sb_name'),
        primary_key=True
    )
    car_a_code = db.Column(
        db.String(CODE_LEN),
        db.ForeignKey('account.a_code'),
        nullable=True
    )
    # end foreign keys

    def __init__(self, car_c_identity_code, car_sb_name, car_a_code, car_last_visit_time):
        self.car_c_identity_code = car_c_identity_code
        self.car_sb_name = car_sb_name
        self.car_a_code = car_a_code
        self.car_last_visit_time = car_last_visit_time

    pass


class SavingsAccountRecord(db.Model):
    # start attributes
    sar_last_visit_time = db.Column(db.Date, nullable=False)
    # end attributes

    # start foreign keys
    sar_c_identity_code = db.Column(
        db.String(IDENTITY_CODE_LEN),
        db.ForeignKey('customer.c_identity_code'),
        primary_key=True
    )
    sar_sb_name = db.Column(
        db.String(NAME_LEN),
        db.ForeignKey('sub_bank.sb_name'),
        primary_key=True
    )
    sar_a_code = db.Column(
        db.String(CODE_LEN),
        db.ForeignKey('account.a_code'),
        nullable=True
    )
    # end foreign keys

    def __init__(self, sar_c_identity_code, sar_sb_name, sar_a_code, sar_last_visit_time):
        self.sar_c_identity_code = sar_c_identity_code
        self.sar_sb_name = sar_sb_name
        self.sar_a_code = sar_a_code
        self.sar_last_visit_time = sar_last_visit_time


    pass


class LoanCustomer(db.Model):
    # start attributes

    # end attributes

    # start foreign keys
    lc_l_code = db.Column(
        db.String(CODE_LEN),
        db.ForeignKey('loan.l_code'),
        primary_key=True
    )
    lc_c_identity_code = db.Column(
        db.String(IDENTITY_CODE_LEN),
        db.ForeignKey('customer.c_identity_code'),
        primary_key=True
    )
    # end foreign keys

    def __init__(self, lc_l_code, lc_c_identity_code):
        self.lc_l_code = lc_l_code
        self.lc_c_identity_code = lc_c_identity_code

    pass

# end models


if __name__ == '__main__':
    pass