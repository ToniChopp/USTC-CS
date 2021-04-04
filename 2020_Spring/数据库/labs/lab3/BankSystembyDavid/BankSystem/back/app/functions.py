from flask_restful import Api, Resource
from .database import *
from flask_restful import reqparse
import datetime
import math

# api instance
api = Api(app)


class CustomerManagement(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('tab',
                        type=str,
                        required=True,
                        choices=['0', '1', '2', '3'],
                        help="tab must in ['0', '1', '2', '3']")

    # query data

    parser.add_argument('customer_id', type=str, required=False)
    parser.add_argument('customer_name', type=str, required=False)
    parser.add_argument('customer_phone', type=str, required=False)
    parser.add_argument('customer_address', type=str, required=False)
    parser.add_argument('contact_name', type=str, required=False)
    parser.add_argument('contact_phone', type=str, required=False)
    parser.add_argument('contact_email', type=str, required=False)
    parser.add_argument('contact_relationship', type=str, required=False)
    parser.add_argument('loan_staff_id', type=str, required=False)
    parser.add_argument('account_staff_id', type=str, required=False)

    # modify data

    parser.add_argument('m_customer_id', type=str, required=False)
    parser.add_argument('m_customer_name', type=str, required=False)
    parser.add_argument('m_customer_phone', type=str, required=False)
    parser.add_argument('m_customer_address', type=str, required=False)
    parser.add_argument('m_contact_name', type=str, required=False)
    parser.add_argument('m_contact_phone', type=str, required=False)
    parser.add_argument('m_contact_email', type=str, required=False)
    parser.add_argument('m_contact_relationship', type=str, required=False)
    parser.add_argument('m_loan_staff_id', type=str, required=False)
    parser.add_argument('m_account_staff_id', type=str, required=False)

    def post(self):
        args = self.parser.parse_args()
        result = {
            'status': True,
            'tab': args['tab'],
            'message': '',
            'data': [],
        }
        convert_dict = {
            'customer_id': 'c_identity_code',
            'customer_name': 'c_name',
            'customer_phone': 'c_phone',
            'customer_address': 'c_address',
            'contact_name': 'c_contact_name',
            'contact_phone': 'c_contact_phone',
            'contact_email': 'c_contact_email',
            'contact_relationship': 'c_contact_relationship',
            'loan_staff_id': 'c_loan_staff_identity_code',
            'account_staff_id': 'c_account_staff_identity_code',
            'm_customer_id': 'c_identity_code',
            'm_customer_name': 'c_name',
            'm_customer_phone': 'c_phone',
            'm_customer_address': 'c_address',
            'm_contact_name': 'c_contact_name',
            'm_contact_phone': 'c_contact_phone',
            'm_contact_email': 'c_contact_email',
            'm_contact_relationship': 'c_contact_relationship',
            'm_loan_staff_id': 'c_loan_staff_identity_code',
            'm_account_staff_id': 'c_account_staff_identity_code',
        }
        reverse_convert_dict = {
            convert_dict[k]: k
            for k in convert_dict
            if not k.startswith('m_') and not k.startswith('tab')
        }

        if args['tab'] == '0':
            # insert
            if args['loan_staff_id'] != '' and result['status']:
                # check if loan staff exists
                staff = Staff.query.filter(
                    Staff.s_identity_code == args['loan_staff_id']).first()
                if staff is None:
                    result['status'] = False
                    result['message'] = '员工不存在'

            if args['account_staff_id'] != '' and result['status']:
                # check if account staff exists
                staff = Staff.query.filter(
                    Staff.s_identity_code == args['account_staff_id']).first()
                if staff is None:
                    result['status'] = False
                    result['message'] = '员工不存在'

            if result['status']:
                # check if customer already exists
                customer = Customer.query.filter(
                    Customer.c_identity_code == args['customer_id']).first()
                if customer is not None:
                    result['status'] = False
                    result['message'] = '客户 ID 已经存在'

            if result['status']:
                init_data = {
                    convert_dict[k]: args[k]
                    for k in args if args[k] != '' and not k.startswith('m_')
                    and not k.startswith('tab')
                }
                db.session.add(Customer(**init_data))
                db.session.commit()
                result['message'] = '插入成功'

        elif args['tab'] == '1':
            # delete
            queries = {
                convert_dict[k]: args[k]
                for k in convert_dict if args[k] != ''
                and not k.startswith('m_') and not k.startswith('tab')
            }
            customers = Customer.query.filter_by(**queries).all()
            if len(customers) == 0:
                # check if have customer which satisfied the queries
                result['status'] = False
                result['message'] = '没有查找到待删除内容'
            if result['status']:
                # check delete conditions
                for c in customers:
                    car_account = CheckingAccountRecord.query.filter_by(
                        car_c_identity_code=c.c_identity_code).first()
                    sar_account = SavingsAccountRecord.query.filter_by(
                        sar_c_identity_code=c.c_identity_code).first()
                    customer_loan = LoanCustomer.query.filter_by(
                        lc_c_identity_code=c.c_identity_code).first()
                    if car_account is not None or sar_account is not None or customer_loan is not None:
                        result['status'] = False
                        result['message'] = '客户不可删除'
            if result['status']:
                customers_num = len(customers)
                for c in customers:
                    db.session.delete(c)
                db.session.commit()
                result['message'] = '删除成功'

        elif args['tab'] == '2':
            queries = {
                convert_dict[k]: args[k]
                for k in convert_dict if args[k] != ''
                and not k.startswith('m_') and not k.startswith('tab')
            }
            customers = Customer.query.filter_by(**queries).all()
            modify_data = {
                convert_dict[k]: args[k]
                for k in args if k.startswith('m_')
            }
            if len(customers) == 0:
                # check if have customer which satisfied the queries
                result['status'] = False
                result['message'] = '未找到待更改内容'
            if result['status']:
                # check staff foreign key
                if modify_data['c_loan_staff_identity_code'] != '':
                    loan_staff = Staff.query.filter_by(
                        s_identity_code=modify_data[
                            'c_loan_staff_identity_code']).first()
                else:
                    loan_staff = -1
                if modify_data['c_account_staff_identity_code'] != '':
                    account_staff = Staff.query.filter_by(
                        s_identity_code=modify_data[
                            'c_account_staff_identity_code']).first()
                else:
                    account_staff = -1

                if loan_staff is None or account_staff is None:
                    result['status'] = False
                    result['message'] = '员工不存在'

            if result['status']:
                if modify_data['c_identity_code'] == '':
                    # if not modify primary key
                    for c in customers:
                        if modify_data['c_name'] != '':
                            c.c_name = modify_data['c_name']
                        if modify_data['c_phone'] != '':
                            c.c_phone = modify_data['c_phone']
                        if modify_data['c_address'] != '':
                            c.c_address = modify_data['c_address']
                        if modify_data['c_contact_name'] != '':
                            c.c_contact_name = modify_data['c_contact_name']
                        if modify_data['c_contact_email'] != '':
                            c.c_contact_email = modify_data['c_contact_email']
                        if modify_data['c_contact_phone'] != '':
                            c.c_contact_phone = modify_data['c_contact_phone']
                        if modify_data['c_contact_relationship'] != '':
                            c.c_contact_relationship = modify_data[
                                'c_contact_relationship']
                        if modify_data['c_loan_staff_identity_code'] != '':
                            c.c_loan_staff_identity_code = modify_data[
                                'c_loan_staff_identity_code']
                        if modify_data['c_account_staff_identity_code'] != '':
                            c.c_account_staff_identity_code = modify_data[
                                'c_account_staff_identity_code']
                        db.session.commit()
                    result['message'] = '更改成功'
                else:
                    if len(customers) != 1:
                        result['message'] = '多个客户满足条件，不可更改'
                        result['status'] = False
                    if result['status']:
                        sql = '''
                        SET FOREIGN_KEY_CHECKS=0;
                        '''
                        db.session.execute(sql)
                        # check new primary key
                        customers_check = Customer.query.filter_by(
                            c_identity_code=modify_data['c_identity_code']
                        ).first()
                        if customers_check is not None:
                            result['message'] = '客户已经存在'
                            result['status'] = False
                    if result['status']:
                        # modify
                        for c in customers:
                            # loop only once
                            old_c_identity_code = c.c_identity_code
                            c.c_identity_code = modify_data['c_identity_code']
                            if modify_data['c_name'] != '':
                                c.c_name = modify_data['c_name']
                            if modify_data['c_phone'] != '':
                                c.c_phone = modify_data['c_phone']
                            if modify_data['c_address'] != '':
                                c.c_address = modify_data['c_address']
                            if modify_data['c_contact_name'] != '':
                                c.c_contact_name = modify_data[
                                    'c_contact_name']
                            if modify_data['c_contact_email'] != '':
                                c.c_contact_email = modify_data[
                                    'c_contact_email']
                            if modify_data['c_contact_phone'] != '':
                                c.c_contact_phone = modify_data[
                                    'c_contact_phone']
                            if modify_data['c_contact_relationship'] != '':
                                c.c_contact_relationship = modify_data[
                                    'c_contact_relationship']
                            if modify_data['c_loan_staff_identity_code'] != '':
                                c.c_loan_staff_identity_code = modify_data[
                                    'c_loan_staff_identity_code']
                            if modify_data[
                                    'c_account_staff_identity_code'] != '':
                                c.c_account_staff_identity_code = modify_data[
                                    'c_account_staff_identity_code']
                            db.session.commit()
                            # modify Account and loan

                            car_accounts = CheckingAccountRecord.query.filter_by(
                                car_c_identity_code=old_c_identity_code).all()
                            sar_accounts = SavingsAccountRecord.query.filter_by(
                                sar_c_identity_code=old_c_identity_code).all()
                            customer_loans = LoanCustomer.query.filter_by(
                                lc_c_identity_code=old_c_identity_code).all()

                            for i in range(len(car_accounts)):
                                car_accounts[
                                    i].car_c_identity_code = modify_data[
                                        'c_identity_code']
                            for i in range(len(sar_accounts)):
                                sar_accounts[
                                    i].sar_c_identity_code = modify_data[
                                        'c_identity_code']
                            for i in range(len(customer_loans)):
                                customer_loans[
                                    i].lc_c_identity_code = modify_data[
                                        'c_identity_code']
                            db.session.commit()
                        sql = '''
                        SET FOREIGN_KEY_CHECKS=1;
                        '''
                        db.session.execute(sql)
                        result['message'] = '更改成功'

        else:
            # query
            queries = {
                convert_dict[k]: args[k]
                for k in convert_dict if args[k] != ''
                and not k.startswith('m_') and not k.startswith('tab')
            }
            customers = Customer.query.filter_by(**queries).all()
            if len(customers) != 0:
                result['message'] = '查找成功'
                for c in customers:
                    d_tmp = c.to_json()
                    d = {reverse_convert_dict[k]: d_tmp[k] for k in d_tmp}
                    result['data'].append(d)
            else:
                result['status'] = False
                result['message'] = '无结果'

        return result


class AccountManagement(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('tab_out',
                        type=str,
                        required=True,
                        choices=['0', '1'],
                        help="tab_out must in ['0', '1']")
    parser.add_argument('tab_in',
                        type=str,
                        required=True,
                        choices=['0', '1', '2', '3'],
                        help="tab_in must in ['0', '1', '2', '3']")
    parser.add_argument('i_account_id', type=str, required=False)
    parser.add_argument('i_account_balance', type=str, required=False)
    parser.add_argument('i_account_open_bank', type=str, required=False)
    parser.add_argument('i_account_open_date', type=str, required=False)
    parser.add_argument('i_account_last_visit_date', type=str, required=False)
    parser.add_argument('i_account_type',
                        type=str,
                        required=True,
                        choices=['Checking', 'Savings'],
                        help="Account type must in ['Checking', 'Savings']")
    parser.add_argument('i_account_customer_id', type=str, required=False)
    parser.add_argument('i_account_credit', type=str, required=False)
    parser.add_argument('i_account_rate', type=str, required=False)
    parser.add_argument('i_account_currency_type', type=str, required=False)

    parser.add_argument('m_account_id', type=str, required=False)
    parser.add_argument('m_account_open_date', type=str, required=False)
    parser.add_argument('m_account_balance', type=str, required=False)
    parser.add_argument('m_account_open_bank', type=str, required=False)
    parser.add_argument('m_account_type',
                        type=str,
                        required=False,
    )
    parser.add_argument('m_account_customer_id', type=str, required=False)
    parser.add_argument('m_account_credit', type=str, required=False)
    parser.add_argument('m_account_rate', type=str, required=False)
    parser.add_argument('m_account_currency_type', type=str, required=False)
    parser.add_argument('m_account_last_visit_date', type=str, required=False)

    def post(self):
        args = self.parser.parse_args()
        result = {
            'status': True,
            'tab_in': args['tab_in'],
            'tab_out': args['tab_out'],
            'message': '',
            'data': [],
        }
        convert_dict_account = {
            'i_account_id': 'a_code',
            'i_account_balance': 'a_balance',
            'i_account_open_date': 'a_open_date',
            'i_account_open_bank': 'a_open_bank'
        }
        convert_dict_savings_account = {
            'i_account_id': 'sa_a_code',
            'i_account_rate': 'sa_rate',
            'i_account_currency_type': 'sa_currency_type'
        }
        convert_dict_checking_account = {
            'i_account_credit': 'ca_credit',
            'i_account_id': 'ca_a_code'
        }
        convert_dict_checking_account_record = {
            'i_account_last_visit_date': 'car_last_visit_time',
            'i_account_customer_id': 'car_c_identity_code',
            'i_account_open_bank': 'car_sb_name',
            'i_account_id': 'car_a_code'
        }
        convert_dict_savings_account_record = {
            'i_account_last_visit_date': 'sar_last_visit_time',
            'i_account_customer_id': 'sar_c_identity_code',
            'i_account_open_bank': 'sar_sb_name',
            'i_account_id': 'sar_a_code'
        }

        if args['tab_out'] == '0':
            if args['tab_in'] == '0':
                # insert account
                if result['status']:
                    # check if account id is exist or not
                    account = Account.query.filter_by(
                        a_code=args['i_account_id']).first()
                    if account is not None:
                        result['status'] = False
                        result['message'] = '账户 ID 已经存在'
                if result['status']:
                    # check if sub bank is exist
                    bank = SubBank.query.filter_by(
                        sb_name=args['i_account_open_bank']).first()
                    if bank is None:
                        result['status'] = False
                        result['message'] = '银行不存在'
                if result['status']:
                    # insert
                    account_info = {
                        convert_dict_account[k]: args[k]
                        for k in convert_dict_account
                    }
                    db.session.add(Account(**account_info))
                    db.session.commit()
                    if args['i_account_type'] == 'Savings':
                        savings_account_info = {
                            convert_dict_savings_account[k]: args[k]
                            for k in convert_dict_savings_account
                        }
                        db.session.add(SavingsAccount(**savings_account_info))
                    else:
                        checking_account_info = {
                            convert_dict_checking_account[k]: args[k]
                            for k in convert_dict_checking_account
                        }
                        db.session.add(
                            CheckingAccount(**checking_account_info))
                    db.session.commit()
                    result['message'] = "插入成功"

            elif args['tab_in'] == '1':
                account_queries = {
                    convert_dict_account[k]: args[k]
                    for k in convert_dict_account if args[k] != ''
                }
                ids = [
                    item.a_code for item in Account.query.filter_by(
                        **account_queries).all()
                ]
                if args['i_account_type'] == 'Savings':
                    savings_account_queries = {
                        convert_dict_savings_account[k]: args[k]
                        for k in convert_dict_savings_account if args[k] != ''
                    }
                    print(savings_account_queries)
                    id_accounts = [
                        item.sa_a_code
                        for item in SavingsAccount.query.filter_by(
                            **savings_account_queries).all()
                    ]
                    print(id_accounts)
                else:
                    checking_account_queries = {
                        convert_dict_checking_account[k]: args[k]
                        for k in convert_dict_checking_account if args[k] != ''
                    }
                    print(checking_account_queries)
                    id_accounts = [
                        item.ca_a_code
                        for item in CheckingAccount.query.filter_by(
                            **checking_account_queries).all()
                    ]
                    print(id_accounts)
                accounts_id = [item for item in ids if item in id_accounts]
                if len(accounts_id) != 0:
                    for a_id in accounts_id:
                        # delete account
                        db.session.delete(
                            Account.query.filter_by(a_code=a_id).first())
                        if args['i_account_type'] == 'Savings':
                            # db.session.delete(SavingsAccount.query.filter_by(sa_a_code=a_id).all())
                            records = SavingsAccountRecord.query.filter_by(
                                sar_a_code=a_id).all()
                            for r in records:
                                db.session.delete(r)
                        else:
                            # db.session.delete(CheckingAccount.query.filter_by(ca_a_code=a_id).first())
                            records = CheckingAccountRecord.query.filter_by(
                                car_a_code=a_id).all()
                            for r in records:
                                db.session.delete(r)
                        db.session.commit()
                    result[
                        'message'] = '删除成功' 
                else:
                    result['status'] = False
                    result['message'] = '删除失败'
            elif args['tab_in'] == '2':
                account_queries = {
                    convert_dict_account[k]: args[k]
                    for k in convert_dict_account if args[k] != ''
                }
                ids = [
                    item.a_code for item in Account.query.filter_by(
                        **account_queries).all()
                ]
                if args['i_account_type'] == 'Savings':
                    savings_account_queries = {
                        convert_dict_savings_account[k]: args[k]
                        for k in convert_dict_savings_account if args[k] != ''
                    }
                    id_accounts = [
                        item.sa_a_code
                        for item in SavingsAccount.query.filter_by(
                            **savings_account_queries).all()
                    ]
                else:
                    checking_account_queries = {
                        convert_dict_checking_account[k]: args[k]
                        for k in convert_dict_checking_account if args[k] != ''
                    }
                    id_accounts = [
                        item.ca_a_code
                        for item in CheckingAccount.query.filter_by(
                            **checking_account_queries).all()
                    ]
                accounts_id = [item for item in ids if item in id_accounts]
                if len(accounts_id) == 0:
                    result['status'] = False
                    result['message'] = '更改失败，找不到待更改内容'
                if result['status']:
                    for a_id in accounts_id:
                        if args['m_account_balance'] != '':
                            # if modify balance
                            acc = Account.query.filter_by(a_code=a_id).first()
                            acc.a_balance = args['m_account_balance']
                        if args['i_account_type'] == 'Savings':
                            acc = SavingsAccount.query.filter_by(
                                sa_a_code=a_id).first()
                            if args['m_account_rate'] != '':
                                acc.sa_rate = args['m_account_rate']
                            elif args['m_account_currency_type']:
                                acc.sa_currency_type = args[
                                    'm_account_currency_type']
                        else:
                            acc = CheckingAccount.query.filter_by(
                                ca_a_code=a_id).first()
                            if args['m_account_credit'] != '':
                                acc.ca_credit = args['m_account_credit']
                        db.session.commit()
                    result[
                        'message'] = '更改成功'
            else:
                # query
                account_queries = {
                    convert_dict_account[k]: args[k]
                    for k in convert_dict_account if args[k] != ''
                }
                ids = [
                    item.a_code for item in Account.query.filter_by(
                        **account_queries).all()
                ]
                if args['i_account_type'] == 'Savings':
                    savings_account_queries = {
                        convert_dict_savings_account[k]: args[k]
                        for k in convert_dict_savings_account if args[k] != ''
                    }
                    id_accounts = [
                        item.sa_a_code
                        for item in SavingsAccount.query.filter_by(
                            **savings_account_queries).all()
                    ]
                else:
                    checking_account_queries = {
                        convert_dict_checking_account[k]: args[k]
                        for k in convert_dict_checking_account if args[k] != ''
                    }
                    # checking_account_record_queries = {convert_dict_checking_account_record[k]: args[k] for k in
                    #                                    convert_dict_checking_account_record if args[k] != ''}
                    id_accounts = [
                        item.ca_a_code
                        for item in CheckingAccount.query.filter_by(
                            **checking_account_queries).all()
                    ]
                    # id_records = [item.car_a_code for item in
                    #               CheckingAccountRecord.query.filter_by(**checking_account_record_queries).all()]
                # join
                accounts_id = [item for item in ids if item in id_accounts]
                if len(accounts_id) != 0:
                    for item in accounts_id:
                        account_info = Account.query.filter_by(
                            a_code=item).first()
                        tmp = {
                            'account_type': args['i_account_type'],
                            'account_id': item,
                            'account_balance': str(account_info.a_balance),
                            'account_open_date': str(account_info.a_open_date),
                            'account_open_bank': account_info.a_open_bank
                        }
                        if args['i_account_type'] == 'Savings':
                            account_ty_info = SavingsAccount.query.filter_by(
                                sa_a_code=item).first()
                            tmp['account_rate'] = str(account_ty_info.sa_rate)
                            tmp['account_currency_type'] = account_ty_info.sa_currency_type
                            tmp['account_credit'] = 'Null'
                        else:
                            account_ty_info = CheckingAccount.query.filter_by(
                                ca_a_code=item).first()
                            tmp['account_credit'] = str(
                                account_ty_info.ca_credit)
                            tmp['account_rate'] = 'Null'
                            tmp['account_currency_type'] = 'Null'
                        result['data'].append(tmp)
                    result['message'] = '查询成功'
                else:
                    result['status'] = False
                    result['message'] = '无查询结果'
        else:
            if args['tab_in'] == '0':
                # insert record
                if result['status']:
                    # check if customer exists
                    customer = Customer.query.filter_by(
                        c_identity_code=args['i_account_customer_id']).first()
                    print('i_account_customer_id')
                    if customer is None:
                        result['status'] = False
                        result['message'] = '客户不存在'

                if result['status']:
                    # check if bank exist
                    bank = SubBank.query.filter_by(
                        sb_name=args['i_account_open_bank']).first()
                    if bank is None:
                        result['status'] = False
                        result['message'] = '银行不存在'

                if result['status']:
                    # check if account exist
                    account = Account.query.filter_by(
                        a_code=args['i_account_id']).first()
                    if account is None:
                        result['status'] = False
                        result['message'] = '账户不存在'

                if result['status']:
                    # check if the customer already has an account in the bank
                    if args['i_account_type'] == 'Savings':
                        account_record = SavingsAccountRecord.query.filter_by(
                            sar_c_identity_code=args['i_account_customer_id'],
                            sar_sb_name=args['i_account_open_bank']).first()
                    else:
                        account_record = CheckingAccountRecord.query.filter_by(
                            car_c_identity_code=args['i_account_customer_id'],
                            car_sb_name=args['i_account_open_bank']).first()
                    if account_record is not None:
                        result['status'] = False
                        result[
                            'message'] = '该客户在该行已有该类型的账户'

                if result['status']:
                    # check if the account type.
                    if args['i_account_type'] == 'Savings':
                        account = SavingsAccount.query.filter_by(
                            sa_a_code=args['i_account_id']).first()
                    else:
                        account = CheckingAccount.query.filter_by(
                            ca_a_code=args['i_account_id']).first()
                    if account is None:
                        result['status'] = False
                        result[
                            'message'] = '账户类型不匹配'

                if result['status']:
                    # check consistency on the open bank
                    account = Account.query.filter_by(
                        a_code=args['i_account_id']).first()
                    a_open_bank = account.a_open_bank
                    if a_open_bank != args['i_account_open_bank']:
                        result['status'] = False
                        result[
                            'message'] = "银行不匹配"

                if result['status']:
                    if args['i_account_type'] == 'Savings':
                        d = {
                            convert_dict_savings_account_record[k]: args[k]
                            for k in convert_dict_savings_account_record
                        }
                        db.session.add(SavingsAccountRecord(**d))
                    else:
                        d = {
                            convert_dict_checking_account_record[k]: args[k]
                            for k in convert_dict_checking_account_record
                        }
                        db.session.add(CheckingAccountRecord(**d))
                    db.session.commit()
                    result['message'] = '插入成功'

            elif args['tab_in'] == '1':
                if args['i_account_type'] == "Savings":
                    query = {
                        convert_dict_savings_account_record[k]: args[k]
                        for k in convert_dict_savings_account_record
                        if args[k] != ''
                    }
                    records = SavingsAccountRecord.query.filter_by(
                        **query).all()

                else:
                    query = {
                        convert_dict_checking_account_record[k]: args[k]
                        for k in convert_dict_checking_account_record
                        if args[k] != ''
                    }
                    records = CheckingAccountRecord.query.filter_by(
                        **query).all()
                if len(records) == 0:
                    result['status'] = False
                    result['message'] = '删除失败，无待删除内容'
                if result['status']:
                    num = len(records)
                    for r in records:
                        db.session.delete(r)
                        db.session.commit()
                    result['message'] = '删除成功'

            elif args['tab_in'] == '2':
                if args['i_account_type'] == "Savings":
                    query = {
                        convert_dict_savings_account_record[k]: args[k]
                        for k in convert_dict_savings_account_record
                        if args[k] != ''
                    }
                    records = SavingsAccountRecord.query.filter_by(
                        **query).all()

                else:
                    query = {
                        convert_dict_checking_account_record[k]: args[k]
                        for k in convert_dict_checking_account_record
                        if args[k] != ''
                    }
                    records = CheckingAccountRecord.query.filter_by(
                        **query).all()
                if len(records) == 0:
                    result['status'] = False
                    result['message'] = '更改失败，无待更改内容'
                if result['status']:
                    num = len(records)
                    for r in records:
                        if args['i_account_type'] == "Savings":
                            r.sar_last_visit_time = args[
                                'm_account_last_visit_date']
                        else:
                            r.car_last_visit_time = args[
                                'm_account_last_visit_date']
                        db.session.commit()
                    result['message'] = '更改成功'
            else:
                if args['i_account_type'] == "Savings":
                    query = {
                        convert_dict_savings_account_record[k]: args[k]
                        for k in convert_dict_savings_account_record
                        if args[k] != ''
                    }
                    records = SavingsAccountRecord.query.filter_by(
                        **query).all()
                    for r in records:
                        result['data'].append({
                            'account_id':
                            r.sar_a_code,
                            'customer_id':
                            r.sar_c_identity_code,
                            'account_type':
                            args['i_account_type'],
                            'account_open_bank':
                            r.sar_sb_name,
                            'account_last_visit_date':
                            str(r.sar_last_visit_time)
                        })
                else:
                    query = {
                        convert_dict_checking_account_record[k]: args[k]
                        for k in convert_dict_checking_account_record
                        if args[k] != ''
                    }
                    records = CheckingAccountRecord.query.filter_by(
                        **query).all()
                    if len(records) == 0:
                        result['status'] = False
                        result['message'] = '无查询结果'
                    for r in records:
                        result['data'].append({
                            'account_id':
                            r.car_a_code,
                            'customer_id':
                            r.car_c_identity_code,
                            'account_type':
                            args['i_account_type'],
                            'account_open_bank':
                            r.car_sb_name,
                            'account_last_visit_date':
                            str(r.car_last_visit_time)
                        })
        return result


class LoanManagement(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('tab_out',
                        type=str,
                        required=True,
                        choices=['0', '1', '2'],
                        help="tab_out must in ['0', '1', '2']")
    parser.add_argument('tab_in',
                        type=str,
                        required=True,
                        choices=['0', '1', '2', '3'],
                        help="tab_in must in ['0', '1', '2', '3']")
    parser.add_argument('loan_id', type=str, required=False)
    parser.add_argument('loan_payment_id', type=str, required=False)
    parser.add_argument('bank_name', type=str, required=False)
    parser.add_argument('money', type=str, required=False)
    parser.add_argument('customer_id', type=str, required=False)
    parser.add_argument('loan_payment_date', type=str, required=False)

    def post(self):
        args = self.parser.parse_args()
        convert_dict_loan = {
            'loan_id': 'l_code',
            'bank_name': 'l_sb_name',
            'money': 'l_money'
        }
        convert_dict_loan_payment = {
            'loan_id': 'lp_l_code',
            'loan_payment_id': 'lp_code',
            'loan_payment_date': 'lp_date',
            'money': 'lp_money'
        }
        convert_dict_loan_customer = {
            'customer_id': 'lc_c_identity_code',
            'loan_id': 'lc_l_code'
        }
        result = {
            'status': True,
            'tab_out': args['tab_out'],
            'tab_in': args['tab_in'],
            'message': '',
            'data': [],
        }
        if args['tab_out'] == '0':
            if args['tab_in'] == '0':
                # insert loan
                if result['status']:
                    # check if loan already exist
                    loan = Loan.query.filter_by(l_code=args['loan_id']).first()
                    if loan is not None:
                        result['status'] = False
                        result['message'] = '贷款 ID 已经存在'
                if result['status']:
                    # check if bank already exist
                    bank = SubBank.query.filter_by(
                        sb_name=args['bank_name']).first()
                    if bank is None:
                        result['status'] = False
                        result['message'] = '银行不存在'

                if result['status']:
                    info = {
                        convert_dict_loan[k]: args[k]
                        for k in convert_dict_loan
                    }
                    db.session.add(Loan(**info))
                    db.session.commit()
                    result['message'] = '新建贷款成功'
            elif args['tab_in'] == '1':
                query = {
                    convert_dict_loan[k]: args[k]
                    for k in convert_dict_loan if args[k] != ''
                }
                loans = Loan.query.filter_by(**query).all()
                if len(loans) == 0:
                    result['status'] = False
                    result['message'] = "删除失败，未找到待删除内容"
                if result['status']:
                    flag = True
                    for l in loans:
                        l_money = l.l_money
                        loan_payments = LoanPayment.query.filter_by(
                            lp_l_code=l.l_code).all()
                        lp_money = 0
                        for lp in loan_payments:
                            lp_money += lp.lp_money
                        if not math.isclose(l_money, lp_money):
                            flag = False
                    if not flag:
                        result['status'] = False
                        result['message'] = "贷款支付未完成"
                if result['status']:
                    num = len(loans)
                    for l in loans:
                        loan_payments = LoanPayment.query.filter_by(
                            lp_l_code=l.l_code).all()
                        for lp in loan_payments:
                            db.session.delete(lp)
                        loan_customers = LoanCustomer.query.filter_by(
                            lc_l_code=l.l_code).all()
                        for lc in loan_customers:
                            db.session.delete(lc)
                        db.session.delete(l)
                        db.session.commit()
                    result['message'] = "删除成功"
            else:
                query = {
                    convert_dict_loan[k]: args[k]
                    for k in convert_dict_loan if args[k] != ''
                }
                loans = Loan.query.filter_by(**query).all()
                if len(loans) == 0:
                    result['status'] = False
                    result['message'] = "查询无结果"
                if result['status']:
                    for l in loans:
                        l_money = l.l_money
                        loan_payments = LoanPayment.query.filter_by(
                            lp_l_code=l.l_code).all()
                        lp_money = 0
                        for lp in loan_payments:
                            lp_money += lp.lp_money
                        if lp_money == 0:
                            loan_status = 'Loan distribution not started'
                        elif math.isclose(l_money, lp_money):
                            loan_status = 'Loan distribution already finished'
                        else:
                            loan_status = 'Loan distribution in progress'

                        result['data'].append({
                            'loan_id': l.l_code,
                            'money': l.l_money,
                            'bank_name': l.l_sb_name,
                            'loan_status': loan_status
                        })
                    result['message'] = "查询成功"
        elif args['tab_out'] == '1':
            if args['tab_in'] == '0':
                # insert loan customer
                if result['status']:
                    loan = Loan.query.filter_by(l_code=args['loan_id']).first()
                    if loan is None:
                        result['status'] = False
                        result['message'] = '贷款号不存在'
                if result['status']:
                    customer = Customer.query.filter_by(
                        c_identity_code=args['customer_id']).first()
                    if customer is None:
                        result['status'] = False
                        result['message'] = '客户 ID 不存在'
                if result['status']:
                    loan_customer = LoanCustomer.query.filter_by(
                        lc_c_identity_code=args['customer_id'],
                        lc_l_code=args['loan_id']).first()
                    if loan_customer is not None:
                        result['status'] = False
                        result['message'] = '该客户已经有贷款'
                if result['status']:
                    info = {
                        convert_dict_loan_customer[k]: args[k]
                        for k in convert_dict_loan_customer
                    }
                    db.session.add(LoanCustomer(**info))
                    db.session.commit()
                    result['message'] = '插入成功'

            elif args['tab_in'] == '1':
                query = {
                    convert_dict_loan_customer[k]: args[k]
                    for k in convert_dict_loan_customer if args[k] != ''
                }
                records = LoanCustomer.query.filter_by(**query).all()
                if len(records) == 0:
                    result['status'] = False
                    result['message'] = "删除失败，无待删除内容"
                if result['status']:
                    num = len(records)
                    for r in records:
                        db.session.delete(r)
                    db.session.commit()
                    result['message'] = "删除成功"
            else:
                query = {
                    convert_dict_loan_customer[k]: args[k]
                    for k in convert_dict_loan_customer if args[k] != ''
                }
                records = LoanCustomer.query.filter_by(**query).all()
                if len(records) == 0:
                    result['status'] = False
                    result['message'] = "无查询结果"
                if result['status']:
                    for r in records:
                        result['data'].append({
                            'loan_id':
                            r.lc_l_code,
                            'customer_id':
                            r.lc_c_identity_code
                        })
                    result['message'] = "查询成功"
        else:
            if args['tab_in'] == '0':
                if result['status']:
                    loan = Loan.query.filter_by(l_code=args['loan_id']).first()
                    if loan is None:
                        result['status'] = False
                        result['message'] = '贷款 ID 不存在'
                if result['status']:
                    loan_payment = LoanPayment.query.filter_by(
                        lp_code=args['loan_payment_id'],
                        lp_l_code=args['loan_id']).first()
                    if loan_payment is not None:
                        result['status'] = False
                        result['message'] = '贷款号不存在'
                max_money = 0
                if result['status']:
                    loan = Loan.query.filter_by(l_code=args['loan_id']).first()
                    l_money = loan.l_money
                    loan_payments = LoanPayment.query.filter_by(
                        lp_l_code=args['loan_id']).all()
                    lp_money = 0
                    for lp in loan_payments:
                        lp_money += lp.lp_money
                    if math.isclose(l_money, lp_money):
                        result['status'] = False
                        result[
                            'message'] = '贷款发放已完成'
                    else:
                        max_money = l_money - lp_money
                if result['status']:
                    if float(args['money']) > max_money:
                        args['money'] = str(max_money)
                    info = {
                        convert_dict_loan_payment[k]: args[k]
                        for k in convert_dict_loan_payment
                    }
                    db.session.add(LoanPayment(**info))
                    db.session.commit()
                    result['message'] = '插入成功'

            elif args['tab_in'] == '1':
                query = {
                    convert_dict_loan_payment[k]: args[k]
                    for k in convert_dict_loan_payment if args[k] != ''
                }
                loan_payments = LoanPayment.query.filter_by(**query).all()
                if len(loan_payments) == 0:
                    result['status'] = False
                    result['message'] = "删除失败，无待删除内容"
                if result['status']:
                    num = len(loan_payments)
                    for lp in loan_payments:
                        db.session.delete(lp)
                    db.session.commit()
                    result['message'] = "删除成功"
            else:
                query = {
                    convert_dict_loan_payment[k]: args[k]
                    for k in convert_dict_loan_payment if args[k] != ''
                }
                loan_payments = LoanPayment.query.filter_by(**query).all()
                if len(loan_payments) == 0:
                    result['status'] = False
                    result['message'] = "无查询记录"
                if result['status']:
                    for lp in loan_payments:
                        result['data'].append({
                            'loan_id':
                            lp.lp_l_code,
                            'loan_payment_id':
                            lp.lp_code,
                            'loan_payment_date':
                            str(lp.lp_date),
                            'money':
                            lp.lp_money
                        })
                    result['message'] = "查询成功"

        return result


class BusinessStatistic(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('business_type',
                        type=str,
                        required=True,
                        choices=['Savings', 'Loan'],
                        help="business_type must in ['Savings', 'Loan']")
    parser.add_argument('time_step',
                        type=str,
                        required=True,
                        choices=['Day', 'Month', 'Year'],
                        help="time_step must in ['Day', 'Month', 'Year']")
    parser.add_argument('start_time',
                        type=str,
                        required=True,
                        help="Must contain start_time")
    parser.add_argument('end_time',
                        type=str,
                        required=True,
                        help="Must contain end_time")

    def post(self):
        args = self.parser.parse_args()
        banks = [item.sb_name for item in SubBank.query.all()]
        result = {
            'success': 1,
            'business_type': args['business_type'],
            'start_time': args['start_time'],
            'end_time': args['end_time'],
            'data': []
        }
        start_time = datetime.date(*map(int, args['start_time'].split('-')))
        end_time = datetime.date(*map(int, args['end_time'].split('-')))

        for b in banks:
            customers = 0
            money = 0
            if args['business_type'] == 'Savings':
                accounts = SavingsAccountRecord.query.filter(
                    SavingsAccountRecord.sar_sb_name == b).all()
                a_id = [x.sar_a_code for x in accounts]
                for id in a_id:
                    tmp = Account.query.filter(Account.a_code == id).filter(
                        Account.a_open_date >= start_time).filter(
                            Account.a_open_date < end_time).first()
                    if tmp is None:
                        continue
                    customers = customers + 1
                    money = money + tmp.a_balance
            else:
                loans = Loan.query.filter(Loan.l_sb_name == b).all()
                for l in loans:
                    tmp = LoanPayment.query.filter(
                        LoanPayment.lp_l_code == l.l_code).filter(
                            LoanPayment.lp_date >= start_time).filter(
                                LoanPayment.lp_date < end_time).all()
                    for t in tmp:
                        money = money + t.lp_money
                    customers = customers + len(
                        LoanCustomer.query.filter(
                            LoanCustomer.lc_l_code == l.l_code).all())
            result["data"].append({
                'bank_name': b,
                'customers': customers,
                'money': money
            })
        return result


api.add_resource(BusinessStatistic, '/api/business-statistic')
api.add_resource(CustomerManagement, '/api/customer-management')
api.add_resource(AccountManagement, '/api/account-management')
api.add_resource(LoanManagement, '/api/loan-management')