import 'package:flutter/material.dart';
import 'package:login_teacher/dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key});

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final supabase = Supabase.instance.client;
  final _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _courseNameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _courseNameController.addListener(() {
      final text = _courseNameController.text.toUpperCase();
      _courseNameController.value = _courseNameController.value.copyWith(
        text: text.replaceAll(' ', ''),
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/2.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: Container(
                width: 400,
                height: 600,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Register Yourself',
                        style: TextStyle(color: Colors.white, fontSize: 33),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formkey,
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _courseNameController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Course Name (eg: CSET101)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Color.fromARGB(255, 153, 160, 180),
                            child: IconButton(
                              color: Colors.white,
                              onPressed: () async {
                                final sm = ScaffoldMessenger.of(context);

                                // retrieving course Id from courses2
                                final courseId = await supabase
                                    .from('courses2')
                                    .select('course_id')
                                    .eq('course_name',
                                        _courseNameController.text);

                                print("CourseID: ${courseId[0]['course_id']}");

                                final Id = courseId[0]['course_id'];

                                // filling the faculty table
                                await supabase.from('faculty').insert({
                                  'name': _nameController.text,
                                  'course_id': Id
                                });

                                //storing faculty id 
                                final faculty_id=await supabase.from('faculty').select('faculty_id').eq('name',_nameController.text );

                                await supabase.auth.signUp(
                                    password: _passwordController.text,
                                    email: _emailController.text,
                                    data:  {
                                      'name': _nameController.text,
                                      'courseName': _courseNameController.text,
                                      'faculty_id':faculty_id
                                    }).then((value) {
                                  sm.showSnackBar(SnackBar(
                                      content: Text(
                                          "Signed up ${value.user!.email!}")));
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DashboardScreen(),
                                      ));
                                }).onError((error, stackTrace) {
                                  sm.showSnackBar(SnackBar(
                                      content: Text("Signed up ${error}")));
                                });
                              },
                              icon: Icon(Icons.arrow_forward),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'login');
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
