from flask import Flask,render_template,request,session,redirect,url_for,flash
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
from werkzeug.security import generate_password_hash,check_password_hash
from flask_login import login_user,logout_user,login_manager,LoginManager
from flask_login import login_required,current_user
from sqlalchemy.exc import SQLAlchemyError
from flask_mail import Mail
from sqlalchemy.orm import sessionmaker
import json
from datetime import datetime

local_server= True
app = Flask(__name__)
app.secret_key='hlghospitals'

login_manager = LoginManager(app)
login_manager.login_view = 'login'

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


app.config['SQLALCHEMY_DATABASE_URI']='mysql://root:@localhost/hms'
db=SQLAlchemy(app)

class User(UserMixin,db.Model):
    id=db.Column(db.Integer,primary_key=True)
    username=db.Column(db.String(50))
    email=db.Column(db.String(50),unique=True)
    role = db.Column(db.String(20), nullable = False)
    password=db.Column(db.String(1000))

class Holidays(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    did = db.Column(db.Integer, db.ForeignKey('doctors.did'), nullable=False)
    date = db.Column(db.Date, nullable=False)

class Booking(db.Model):
    Aptid=db.Column(db.Integer,primary_key=True)
    name=db.Column(db.String(50),nullable=False)
    email=db.Column(db.String(50),nullable=False)
    gender=db.Column(db.String(50))
    slot=db.Column(db.String(50),nullable=False)
    date=db.Column(db.Date,nullable=False)
    dept=db.Column(db.String(50),nullable=False)
    number=db.Column(db.String(50))
    doctor=db.Column(db.String(50))
    descrip=db.Column(db.String(100))

class Log(db.Model):
    id=db.Column(db.Integer,primary_key=True)
    Aptid=db.Column(db.Integer)
    name=db.Column(db.String(50))
    email=db.Column(db.String(50))
    time=db.Column(db.String(50))
    operation=db.Column(db.String(50))

class Doctors(db.Model):
    __tablename__ = 'doctors'
    did=db.Column(db.Integer,primary_key=True)
    email=db.Column(db.String(50))
    name=db.Column(db.String(50))
    dept=db.Column(db.String(50))
    slot=db.Column(db.String(50))



@app.route('/')
def index():
    return render_template('index2.html')

@app.route('/ourDoctors')
def OurDoctors():
    return render_template('ourDoctors.html')

@app.route('/doctors')
@login_required
def doctors():
    doct = Doctors.query.all()
    return render_template('doctors.html', doct = doct)

@app.route('/patients')
@login_required
def patients():
    patient = Booking.query.all()
    return render_template('patients.html', patient=patient)

@app.route('/patienthistory')
@login_required
def patienthistory():
    pati = db.session.query(Booking).filter_by(email=current_user.email).all()
    print(pati)
    return render_template('patienthistory.html', patient=pati)

@app.route('/booking')
@login_required
def booking():
    return render_template('booking.html')

@app.route('/showactivity')
@login_required
def showactivity():
    patient = Log.query.all()
    return render_template('showActivity.html', patient = patient)

@app.route('/patienthome')
@login_required
def patienthome():
    if current_user.role != 'admin':
        return render_template('patienthome.html')
    
    flash("Only for patients! Redirecting you to Admin Home Page")
    return render_template('admin.html')

#_______________________admin_____________________________________
@app.route('/admin',methods=['POST','GET'])
@login_required
def Admin():
    if(current_user.role == 'admin'):
        return render_template('admin.html')
    flash("Login first as admin","warning")
    return render_template('login.html')

@app.route('/addbooking', methods=['GET', 'POST'])
@login_required
def addbooking():
    if request.method == "POST":
        name = request.form['name']
        email = request.form['email']
        gender = request.form['gender']
        slot = request.form['slot']
        date = request.form['date']
        dept = request.form['dept']
        number = request.form['number']
        descrip = request.form['descrip']
        print(current_user.role)
        try:
            doct = db.session.query(Doctors).filter_by(slot=slot, dept=dept).first()
            print('a')
            existing_patient = Booking.query.filter_by(slot=slot, date=date, dept=dept).all()
            length = len(existing_patient)
            print(length) # maximum length+1 bookings can be done on this slot
            if length>1:
                print('b')
                flash("Slots already booked! Try with another one", "danger")
                return redirect(url_for('addbooking'))
            if not doct:
                print('c')
                flash("No doctor available for this Slot", "danger")
                return redirect(url_for('addbooking'))
            holiday = Holidays.query.filter_by(did = doct.did).all()
            for h in holiday:
                dt1 = h.date
                dt2 = date
                dt1 = dt1.strftime("%Y-%m-%d")
                if dt1 == dt2:
                    flash("Doctor not available on this day", "danger")
                    return redirect(url_for('addbooking'))
            
            new_patient = Booking( name=name, email=email, gender=gender, slot=slot,
                            date=date, dept=dept, number=number,doctor=doct.name, descrip=descrip)
            
            db.session.add(new_patient)
            db.session.commit()
            flash("Booking Added Successfully!", "success")
            if current_user.role=='admin':
                return redirect(url_for('patients'))
            else:  
                return redirect(url_for('patienthome'))
        except SQLAlchemyError as e:
            print(e)
            print("______Error______")
            db.session.rollback()  
            flash("Error occurred while Adding", "danger")
            if current_user.role=='admin':
                return redirect(url_for('patients'))
            else:  
                return redirect(url_for('patienthome'))
    return render_template('addbooking.html', current_user=current_user)


@app.route("/deleteBooking/<string:Aptid>")
@login_required
def delete_patient(Aptid):
    patient = Booking.query.get(Aptid)
    if patient:
        db.session.delete(patient)
        db.session.commit()
        flash("Booking Cancelled","danger")
        if current_user.role=='admin':
            return redirect(url_for('patients'))
        else:  
            return redirect(url_for('patienthistory'))
    if current_user.role=='admin':
        render_template('patients.html')
    else:
        render_template('patienthistory.html')



@app.route("/edit/<string:did>",methods=['POST','GET'])
@login_required
def edit(did):
    posts=Doctors.query.get_or_404(did)
    if request.method=="POST":
        posts.email=request.form['email']
        posts.name=request.form['name']
        posts.slot=request.form['slot']
        posts.dept=request.form['dept']
        try:
            db.session.commit()
            flash("Updated Successfully!", "success")
            redirect('/doctors')
        except SQLAlchemyError as e:
            db.session.rollback()  # Rollback the transaction in case of an error
            flash("Error occurred while Updating", "danger")
        return redirect('/doctors')
    return render_template('edit2.html',posts=posts)



@app.route("/addLeave/<string:did>",methods=['POST','GET'])
@login_required
def addLeave(did):
    doctor=Doctors.query.get_or_404(did)
    if request.method=="POST":
        date = request.form['date']
        did = did
        print("c")
        try:
            h = Holidays(did = did, date = date)
            db.session.add(h)
            db.session.commit()
            flash("Leave added successfully!", "success")
            return redirect('/doctors')
        except SQLAlchemyError as e:
            db.session.rollback()  # Rollback the transaction in case of an error
            flash("Error occurred while adding", "danger")
            
        return redirect('/doctors')
    return render_template('addLeave.html',doctor=doctor)


@app.route('/addDoctors', methods=['GET', 'POST'])
@login_required
def addDoctor():
    if request.method == "POST":
        email = request.form['email']
        name = request.form['name']
        slot = request.form['slot']
        dept = request.form['dept']
        try:
            existing_doct = Doctors.query.filter_by(email=email).first()
            if existing_doct:
                flash("Doctor already exists", "danger")
                return redirect(url_for('addDoctor'))
            sameslot = Doctors.query.filter_by(slot = slot, dept=dept).first()
            if sameslot:
                flash("Doctor already present at this slot", "danger")
                return redirect(url_for('addDoctor'))
            new_doct = Doctors(email=email, name=name,slot=slot,  dept=dept, )
            db.session.add(new_doct)
            db.session.commit()
            flash("Doctor Added Successfully!", "success")
            return redirect('/doctors')
        except SQLAlchemyError as e:
            db.session.rollback()  
            flash("Error occurred while Adding", "danger")
    return render_template('addDoctors.html')


@app.route("/delete/<string:did>")
@login_required
def delete(did):
    doct = Doctors.query.get(did)
    if doct:
        bookings = Booking.query.filter_by(doctor = doct.name).all()
        for b in bookings:
            db.session.delete(b)
            db.session.commit()
        db.session.delete(doct)
        db.session.commit()
        flash("Doctor and their corresponding bookings has been deleted Successfully","primary")
        return redirect('/doctors')
    return redirect('/doctors')



#___________________________SignUp and Login______________________
@app.route('/signup', methods=['POST','GET'])
def signup():
    if(request.method == 'POST'):
        username = request.form.get('username')
        email = request.form.get('email')
        password = request.form.get('password')
        role = 'patient'
        user = User.query.filter_by(email= email).first()
        if user:
            print("email already exists")
            return render_template('signup.html')
        
        encpassword=generate_password_hash(password)
        newuser=User(username=username,email=email,role = role,password=encpassword)
        db.session.add(newuser)
        db.session.commit()
        flash("Signup Succes Please Login","success")
        return render_template('login.html')                     
    return render_template('signup.html')

@app.route('/login',methods=['POST','GET'])
def login():
    if request.method == "POST":
        email=request.form.get('email')
        role = request.form.get('role')
        password=request.form.get('password')
        user=User.query.filter_by(email=email).first()
        if user and user.role=='admin' and user.password == 'admin@123':
            login_user(user)
            return render_template('admin.html')
        elif user and user.role == 'patient' and check_password_hash(user.password,password):
            login_user(user)
            patient = User.query.filter_by(email=user.email).first()
            print(patient)
            if patient:
                return render_template("patienthome.html", patient = patient)
            else:
                return "Patient not found", 404
        else:
            print("Invalid credentials")
            flash("invalid credentials","danger")
            return render_template('login.html')
    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash('Logged out successfully!', 'info')

    return redirect(url_for('index'))

#____________When User is Patient and he wants to book___________





@app.route('/test')
def test():
    try:
        Doctors.query.all()
        return 'My Database is connected'
    except:
        return 'My database is not connected'
        
app.run(debug=True)