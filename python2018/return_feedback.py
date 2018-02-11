"""Return feedback to students that was generated with `nbgrader feedback`.
This must be run from the root of the nbgrader directory. You probably need to run
it with sudo since you need to write to other users' directories.
Usage:
    sudo python return_feedback.py problem_set_name
    
"""

import os
import shutil
import pwd
import argparse
import stat


def set_permissions(path, uid, gid):
    os.chown(path, uid, gid)
    if os.path.isdir(path):
        os.chmod(path, stat.S_IRUSR | stat.S_IRGRP | stat.S_IXUSR | stat.S_IXGRP)
    else:
        os.chmod(path, stat.S_IRUSR | stat.S_IRGRP)


def main(name, student=None, force=False):
    feedback_dir = os.path.abspath("feedback")
    solution_dir = os.path.abspath("source")

    if student is None:
        # grab student names that are already in the feedback directory
        students = sorted(os.listdir(feedback_dir))
    else:
        students = [student]

    for student in students:
        # update source directory
        src = os.path.join(feedback_dir, student, name)
        dst = os.path.join("/", "home", student, "feedback", "{}".format(name))
        sol_src = os.path.join(solution_dir, name)
        sol_dst = os.path.join("/", "home", student, "solution", "{}".format(name))
        
        # get the uid and gid
        pwinfo = pwd.getpwnam(student)
        uid = pwinfo.pw_uid
        gid = pwinfo.pw_gid
        
        if os.path.exists(src):
           # remove existing feedback if it exists
            if os.path.exists(dst):
                if force:
                    print("removing '{}'".format(dst))
                    shutil.rmtree(dst)
                else:
                    print("skipping {}, feedback already exists".format(student))
                    continue    
            # copy the feedback        
            print("'{}' --> '{}'".format(src, dst))
            shutil.copytree(src, dst) 
            # set the owner to be the student and permissions to be read-only
            set_permissions(dst, uid, gid)
            for dirname, dirnames, filenames in os.walk(dst):
                for f in (dirnames + filenames):
                    path = os.path.join(dirname, f)
                    set_permissions(path, uid, gid)
        else:
            print("The {stu} hasn't got feedback ".format(stu = student))
        
        # remove existing solution if it exists     
        if os.path.exists(sol_dst):
            if force:
                print("removing '{}'".format(sol_dst))
                shutil.rmtree(sol_dst)
            else:
                print("skipping {}, feedback already exists".format(student))
                continue

        # copy the solution        
        print("'{}' --> '{}'".format(sol_src,sol_dst))
        shutil.copytree(sol_src, sol_dst)
        
        # set the owner to be the student and permissions to be read-only
        set_permissions(sol_dst, uid, gid)
        for dirname, dirnames, filenames in os.walk(sol_dst):
            for f in (dirnames + filenames):
                path = os.path.join(dirname, f)
                set_permissions(path, uid, gid)





if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('name', help='the name of the assignment')
    parser.add_argument('--student', default=None, help='the name of a specific student')
    parser.add_argument('--force', action="store_true", default=False,
                        help='overwrite existing feedback (use with extreme caution!!)')
    args = parser.parse_args()
    main(args.name, student=args.student, force=args.force)