from django.db import models

class TrainingProgram(models.Model):
    course = models.CharField(max_length=100)
    branch = models.CharField(max_length=100)
    year = models.CharField(max_length=10)
    semester = models.CharField(max_length=10)
    section = models.CharField(max_length=10)
    name = models.CharField(max_length=200)
    description = models.TextField()  
    start_date = models.DateField()
    end_date = models.DateField()

    def __str__(self):
        return self.name