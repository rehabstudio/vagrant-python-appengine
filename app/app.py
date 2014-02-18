"""
Simplest webapp2 example possible
"""
# third-party imports
import webapp2


class HelloWebapp2(webapp2.RequestHandler):

    def get(self):
        self.response.write('Hello, webapp2!')


app = webapp2.WSGIApplication([('/', HelloWebapp2)], debug=True)
