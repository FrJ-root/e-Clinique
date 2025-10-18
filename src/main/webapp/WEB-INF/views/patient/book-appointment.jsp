<h4 class="mb-3">
    <i class="fas fa-clock me-2"></i>Créneaux disponibles
</h4>

<div class="alert alert-info" role="alert">
    <i class="fas fa-info-circle me-2"></i>
    Les rendez-vous doivent être pris au moins 2 heures à l'avance.
</div>

<c:choose>
    <c:when test="${not empty timeSlots}">
        <div class="time-slots" id="timeSlots">
            <c:forEach items="${timeSlots}" var="slot" varStatus="status">
                <div class="time-slot"
                     data-start-time="${slot.startTime}"
                     data-end-time="${slot.endTime}">
                    ${slot.displayTime}
                </div>
            </c:forEach>
        </div>
    </c:when>
    <c:otherwise>
        <div class="no-slots-message">
            <i class="fas fa-calendar-times"></i>
            <h4>Aucun créneau disponible</h4>
            <p>Veuillez sélectionner une autre date ou consulter un autre médecin.</p>
        </div>
    </c:otherwise>
</c:choose>